
open Prims

let add_fuel = (fun x tl -> if (FStar_Options.unthrottle_inductives ()) then begin
tl
end else begin
(x)::tl
end)


let withenv = (fun c _86_30 -> (match (_86_30) with
| (a, b) -> begin
((a), (b), (c))
end))


let vargs = (fun args -> (FStar_List.filter (fun _86_1 -> (match (_86_1) with
| (FStar_Util.Inl (_86_34), _86_37) -> begin
false
end
| _86_40 -> begin
true
end)) args))


let subst_lcomp_opt = (fun s l -> (match (l) with
| Some (FStar_Util.Inl (l)) -> begin
(let _179_12 = (let _179_11 = (let _179_10 = (let _179_9 = (l.FStar_Syntax_Syntax.comp ())
in (FStar_Syntax_Subst.subst_comp s _179_9))
in (FStar_All.pipe_left FStar_Syntax_Util.lcomp_of_comp _179_10))
in FStar_Util.Inl (_179_11))
in Some (_179_12))
end
| _86_47 -> begin
l
end))


let escape : Prims.string  ->  Prims.string = (fun s -> (FStar_Util.replace_char s '\'' '_'))


let mk_term_projector_name : FStar_Ident.lident  ->  FStar_Syntax_Syntax.bv  ->  Prims.string = (fun lid a -> (

let a = (

let _86_51 = a
in (let _179_19 = (FStar_Syntax_Util.unmangle_field_name a.FStar_Syntax_Syntax.ppname)
in {FStar_Syntax_Syntax.ppname = _179_19; FStar_Syntax_Syntax.index = _86_51.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _86_51.FStar_Syntax_Syntax.sort}))
in (let _179_20 = (FStar_Util.format2 "%s_%s" lid.FStar_Ident.str a.FStar_Syntax_Syntax.ppname.FStar_Ident.idText)
in (FStar_All.pipe_left escape _179_20))))


let primitive_projector_by_pos : FStar_TypeChecker_Env.env  ->  FStar_Ident.lident  ->  Prims.int  ->  Prims.string = (fun env lid i -> (

let fail = (fun _86_58 -> (match (()) with
| () -> begin
(let _179_30 = (let _179_29 = (FStar_Util.string_of_int i)
in (FStar_Util.format2 "Projector %s on data constructor %s not found" _179_29 lid.FStar_Ident.str))
in (FStar_All.failwith _179_30))
end))
in (

let _86_62 = (FStar_TypeChecker_Env.lookup_datacon env lid)
in (match (_86_62) with
| (_86_60, t) -> begin
(match ((let _179_31 = (FStar_Syntax_Subst.compress t)
in _179_31.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (bs, c) -> begin
(

let _86_70 = (FStar_Syntax_Subst.open_comp bs c)
in (match (_86_70) with
| (binders, _86_69) -> begin
if ((i < (Prims.parse_int "0")) || (i >= (FStar_List.length binders))) then begin
(fail ())
end else begin
(

let b = (FStar_List.nth binders i)
in (mk_term_projector_name lid (Prims.fst b)))
end
end))
end
| _86_73 -> begin
(fail ())
end)
end))))


let mk_term_projector_name_by_pos : FStar_Ident.lident  ->  Prims.int  ->  Prims.string = (fun lid i -> (let _179_37 = (let _179_36 = (FStar_Util.string_of_int i)
in (FStar_Util.format2 "%s_%s" lid.FStar_Ident.str _179_36))
in (FStar_All.pipe_left escape _179_37)))


let mk_term_projector : FStar_Ident.lident  ->  FStar_Syntax_Syntax.bv  ->  FStar_SMTEncoding_Term.term = (fun lid a -> (let _179_43 = (let _179_42 = (mk_term_projector_name lid a)
in ((_179_42), (FStar_SMTEncoding_Term.Arrow (((FStar_SMTEncoding_Term.Term_sort), (FStar_SMTEncoding_Term.Term_sort))))))
in (FStar_SMTEncoding_Term.mkFreeV _179_43)))


let mk_term_projector_by_pos : FStar_Ident.lident  ->  Prims.int  ->  FStar_SMTEncoding_Term.term = (fun lid i -> (let _179_49 = (let _179_48 = (mk_term_projector_name_by_pos lid i)
in ((_179_48), (FStar_SMTEncoding_Term.Arrow (((FStar_SMTEncoding_Term.Term_sort), (FStar_SMTEncoding_Term.Term_sort))))))
in (FStar_SMTEncoding_Term.mkFreeV _179_49)))


let mk_data_tester = (fun env l x -> (FStar_SMTEncoding_Term.mk_tester (escape l.FStar_Ident.str) x))


type varops_t =
{push : Prims.unit  ->  Prims.unit; pop : Prims.unit  ->  Prims.unit; mark : Prims.unit  ->  Prims.unit; reset_mark : Prims.unit  ->  Prims.unit; commit_mark : Prims.unit  ->  Prims.unit; new_var : FStar_Ident.ident  ->  Prims.int  ->  Prims.string; new_fvar : FStar_Ident.lident  ->  Prims.string; fresh : Prims.string  ->  Prims.string; string_const : Prims.string  ->  FStar_SMTEncoding_Term.term; next_id : Prims.unit  ->  Prims.int; mk_unique : Prims.string  ->  Prims.string}


let is_Mkvarops_t : varops_t  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkvarops_t"))))


let varops : varops_t = (

let initial_ctr = (Prims.parse_int "100")
in (

let ctr = (FStar_Util.mk_ref initial_ctr)
in (

let new_scope = (fun _86_98 -> (match (()) with
| () -> begin
(let _179_162 = (FStar_Util.smap_create (Prims.parse_int "100"))
in (let _179_161 = (FStar_Util.smap_create (Prims.parse_int "100"))
in ((_179_162), (_179_161))))
end))
in (

let scopes = (let _179_164 = (let _179_163 = (new_scope ())
in (_179_163)::[])
in (FStar_Util.mk_ref _179_164))
in (

let mk_unique = (fun y -> (

let y = (escape y)
in (

let y = (match ((let _179_168 = (FStar_ST.read scopes)
in (FStar_Util.find_map _179_168 (fun _86_106 -> (match (_86_106) with
| (names, _86_105) -> begin
(FStar_Util.smap_try_find names y)
end))))) with
| None -> begin
y
end
| Some (_86_109) -> begin
(

let _86_111 = (FStar_Util.incr ctr)
in (let _179_171 = (let _179_170 = (let _179_169 = (FStar_ST.read ctr)
in (FStar_Util.string_of_int _179_169))
in (Prims.strcat "__" _179_170))
in (Prims.strcat y _179_171)))
end)
in (

let top_scope = (let _179_173 = (let _179_172 = (FStar_ST.read scopes)
in (FStar_List.hd _179_172))
in (FStar_All.pipe_left Prims.fst _179_173))
in (

let _86_115 = (FStar_Util.smap_add top_scope y true)
in y)))))
in (

let new_var = (fun pp rn -> (let _179_180 = (let _179_179 = (let _179_178 = (FStar_Util.string_of_int rn)
in (Prims.strcat "__" _179_178))
in (Prims.strcat pp.FStar_Ident.idText _179_179))
in (FStar_All.pipe_left mk_unique _179_180)))
in (

let new_fvar = (fun lid -> (mk_unique lid.FStar_Ident.str))
in (

let next_id = (fun _86_123 -> (match (()) with
| () -> begin
(

let _86_124 = (FStar_Util.incr ctr)
in (FStar_ST.read ctr))
end))
in (

let fresh = (fun pfx -> (let _179_188 = (let _179_187 = (next_id ())
in (FStar_All.pipe_left FStar_Util.string_of_int _179_187))
in (FStar_Util.format2 "%s_%s" pfx _179_188)))
in (

let string_const = (fun s -> (match ((let _179_192 = (FStar_ST.read scopes)
in (FStar_Util.find_map _179_192 (fun _86_133 -> (match (_86_133) with
| (_86_131, strings) -> begin
(FStar_Util.smap_try_find strings s)
end))))) with
| Some (f) -> begin
f
end
| None -> begin
(

let id = (next_id ())
in (

let f = (let _179_193 = (FStar_SMTEncoding_Term.mk_String_const id)
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxString _179_193))
in (

let top_scope = (let _179_195 = (let _179_194 = (FStar_ST.read scopes)
in (FStar_List.hd _179_194))
in (FStar_All.pipe_left Prims.snd _179_195))
in (

let _86_140 = (FStar_Util.smap_add top_scope s f)
in f))))
end))
in (

let push = (fun _86_143 -> (match (()) with
| () -> begin
(let _179_200 = (let _179_199 = (new_scope ())
in (let _179_198 = (FStar_ST.read scopes)
in (_179_199)::_179_198))
in (FStar_ST.op_Colon_Equals scopes _179_200))
end))
in (

let pop = (fun _86_145 -> (match (()) with
| () -> begin
(let _179_204 = (let _179_203 = (FStar_ST.read scopes)
in (FStar_List.tl _179_203))
in (FStar_ST.op_Colon_Equals scopes _179_204))
end))
in (

let mark = (fun _86_147 -> (match (()) with
| () -> begin
(push ())
end))
in (

let reset_mark = (fun _86_149 -> (match (()) with
| () -> begin
(pop ())
end))
in (

let commit_mark = (fun _86_151 -> (match (()) with
| () -> begin
(match ((FStar_ST.read scopes)) with
| ((hd1, hd2))::((next1, next2))::tl -> begin
(

let _86_164 = (FStar_Util.smap_fold hd1 (fun key value v -> (FStar_Util.smap_add next1 key value)) ())
in (

let _86_169 = (FStar_Util.smap_fold hd2 (fun key value v -> (FStar_Util.smap_add next2 key value)) ())
in (FStar_ST.op_Colon_Equals scopes ((((next1), (next2)))::tl))))
end
| _86_172 -> begin
(FStar_All.failwith "Impossible")
end)
end))
in {push = push; pop = pop; mark = mark; reset_mark = reset_mark; commit_mark = commit_mark; new_var = new_var; new_fvar = new_fvar; fresh = fresh; string_const = string_const; next_id = next_id; mk_unique = mk_unique})))))))))))))))


let unmangle : FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.bv = (fun x -> (

let _86_174 = x
in (let _179_219 = (FStar_Syntax_Util.unmangle_field_name x.FStar_Syntax_Syntax.ppname)
in {FStar_Syntax_Syntax.ppname = _179_219; FStar_Syntax_Syntax.index = _86_174.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _86_174.FStar_Syntax_Syntax.sort})))


type binding =
| Binding_var of (FStar_Syntax_Syntax.bv * FStar_SMTEncoding_Term.term)
| Binding_fvar of (FStar_Ident.lident * Prims.string * FStar_SMTEncoding_Term.term Prims.option * FStar_SMTEncoding_Term.term Prims.option)


let is_Binding_var = (fun _discr_ -> (match (_discr_) with
| Binding_var (_) -> begin
true
end
| _ -> begin
false
end))


let is_Binding_fvar = (fun _discr_ -> (match (_discr_) with
| Binding_fvar (_) -> begin
true
end
| _ -> begin
false
end))


let ___Binding_var____0 = (fun projectee -> (match (projectee) with
| Binding_var (_86_178) -> begin
_86_178
end))


let ___Binding_fvar____0 = (fun projectee -> (match (projectee) with
| Binding_fvar (_86_181) -> begin
_86_181
end))


let binder_of_eithervar = (fun v -> ((v), (None)))


type env_t =
{bindings : binding Prims.list; depth : Prims.int; tcenv : FStar_TypeChecker_Env.env; warn : Prims.bool; cache : (Prims.string * FStar_SMTEncoding_Term.sort Prims.list * FStar_SMTEncoding_Term.decl Prims.list) FStar_Util.smap; nolabels : Prims.bool; use_zfuel_name : Prims.bool; encode_non_total_function_typ : Prims.bool}


let is_Mkenv_t : env_t  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkenv_t"))))


let print_env : env_t  ->  Prims.string = (fun e -> (let _179_277 = (FStar_All.pipe_right e.bindings (FStar_List.map (fun _86_2 -> (match (_86_2) with
| Binding_var (x, _86_196) -> begin
(FStar_Syntax_Print.bv_to_string x)
end
| Binding_fvar (l, _86_201, _86_203, _86_205) -> begin
(FStar_Syntax_Print.lid_to_string l)
end))))
in (FStar_All.pipe_right _179_277 (FStar_String.concat ", "))))


let lookup_binding = (fun env f -> (FStar_Util.find_map env.bindings f))


let caption_t : env_t  ->  FStar_Syntax_Syntax.term  ->  Prims.string Prims.option = (fun env t -> if (FStar_TypeChecker_Env.debug env.tcenv FStar_Options.Low) then begin
(let _179_287 = (FStar_Syntax_Print.term_to_string t)
in Some (_179_287))
end else begin
None
end)


let fresh_fvar : Prims.string  ->  FStar_SMTEncoding_Term.sort  ->  (Prims.string * FStar_SMTEncoding_Term.term) = (fun x s -> (

let xsym = (varops.fresh x)
in (let _179_292 = (FStar_SMTEncoding_Term.mkFreeV ((xsym), (s)))
in ((xsym), (_179_292)))))


let gen_term_var : env_t  ->  FStar_Syntax_Syntax.bv  ->  (Prims.string * FStar_SMTEncoding_Term.term * env_t) = (fun env x -> (

let ysym = (let _179_297 = (FStar_Util.string_of_int env.depth)
in (Prims.strcat "@x" _179_297))
in (

let y = (FStar_SMTEncoding_Term.mkFreeV ((ysym), (FStar_SMTEncoding_Term.Term_sort)))
in ((ysym), (y), ((

let _86_219 = env
in {bindings = (Binding_var (((x), (y))))::env.bindings; depth = (env.depth + (Prims.parse_int "1")); tcenv = _86_219.tcenv; warn = _86_219.warn; cache = _86_219.cache; nolabels = _86_219.nolabels; use_zfuel_name = _86_219.use_zfuel_name; encode_non_total_function_typ = _86_219.encode_non_total_function_typ}))))))


let new_term_constant : env_t  ->  FStar_Syntax_Syntax.bv  ->  (Prims.string * FStar_SMTEncoding_Term.term * env_t) = (fun env x -> (

let ysym = (varops.new_var x.FStar_Syntax_Syntax.ppname x.FStar_Syntax_Syntax.index)
in (

let y = (FStar_SMTEncoding_Term.mkApp ((ysym), ([])))
in ((ysym), (y), ((

let _86_225 = env
in {bindings = (Binding_var (((x), (y))))::env.bindings; depth = _86_225.depth; tcenv = _86_225.tcenv; warn = _86_225.warn; cache = _86_225.cache; nolabels = _86_225.nolabels; use_zfuel_name = _86_225.use_zfuel_name; encode_non_total_function_typ = _86_225.encode_non_total_function_typ}))))))


let new_term_constant_from_string : env_t  ->  FStar_Syntax_Syntax.bv  ->  Prims.string  ->  (Prims.string * FStar_SMTEncoding_Term.term * env_t) = (fun env x str -> (

let ysym = (varops.mk_unique str)
in (

let y = (FStar_SMTEncoding_Term.mkApp ((ysym), ([])))
in ((ysym), (y), ((

let _86_232 = env
in {bindings = (Binding_var (((x), (y))))::env.bindings; depth = _86_232.depth; tcenv = _86_232.tcenv; warn = _86_232.warn; cache = _86_232.cache; nolabels = _86_232.nolabels; use_zfuel_name = _86_232.use_zfuel_name; encode_non_total_function_typ = _86_232.encode_non_total_function_typ}))))))


let push_term_var : env_t  ->  FStar_Syntax_Syntax.bv  ->  FStar_SMTEncoding_Term.term  ->  env_t = (fun env x t -> (

let _86_237 = env
in {bindings = (Binding_var (((x), (t))))::env.bindings; depth = _86_237.depth; tcenv = _86_237.tcenv; warn = _86_237.warn; cache = _86_237.cache; nolabels = _86_237.nolabels; use_zfuel_name = _86_237.use_zfuel_name; encode_non_total_function_typ = _86_237.encode_non_total_function_typ}))


let lookup_term_var : env_t  ->  FStar_Syntax_Syntax.bv  ->  FStar_SMTEncoding_Term.term = (fun env a -> (

let aux = (fun a' -> (lookup_binding env (fun _86_3 -> (match (_86_3) with
| Binding_var (b, t) when (FStar_Syntax_Syntax.bv_eq b a') -> begin
Some (((b), (t)))
end
| _86_249 -> begin
None
end))))
in (match ((aux a)) with
| None -> begin
(

let a = (unmangle a)
in (match ((aux a)) with
| None -> begin
(let _179_322 = (let _179_321 = (FStar_Syntax_Print.bv_to_string a)
in (FStar_Util.format1 "Bound term variable not found (after unmangling): %s" _179_321))
in (FStar_All.failwith _179_322))
end
| Some (b, t) -> begin
t
end))
end
| Some (b, t) -> begin
t
end)))


let new_term_constant_and_tok_from_lid : env_t  ->  FStar_Ident.lident  ->  (Prims.string * Prims.string * env_t) = (fun env x -> (

let fname = (varops.new_fvar x)
in (

let ftok = (Prims.strcat fname "@tok")
in (let _179_333 = (

let _86_265 = env
in (let _179_332 = (let _179_331 = (let _179_330 = (let _179_329 = (let _179_328 = (FStar_SMTEncoding_Term.mkApp ((ftok), ([])))
in (FStar_All.pipe_left (fun _179_327 -> Some (_179_327)) _179_328))
in ((x), (fname), (_179_329), (None)))
in Binding_fvar (_179_330))
in (_179_331)::env.bindings)
in {bindings = _179_332; depth = _86_265.depth; tcenv = _86_265.tcenv; warn = _86_265.warn; cache = _86_265.cache; nolabels = _86_265.nolabels; use_zfuel_name = _86_265.use_zfuel_name; encode_non_total_function_typ = _86_265.encode_non_total_function_typ}))
in ((fname), (ftok), (_179_333))))))


let try_lookup_lid : env_t  ->  FStar_Ident.lident  ->  (Prims.string * FStar_SMTEncoding_Term.term Prims.option * FStar_SMTEncoding_Term.term Prims.option) Prims.option = (fun env a -> (lookup_binding env (fun _86_4 -> (match (_86_4) with
| Binding_fvar (b, t1, t2, t3) when (FStar_Ident.lid_equals b a) -> begin
Some (((t1), (t2), (t3)))
end
| _86_277 -> begin
None
end))))


let contains_name : env_t  ->  Prims.string  ->  Prims.bool = (fun env s -> (let _179_344 = (lookup_binding env (fun _86_5 -> (match (_86_5) with
| Binding_fvar (b, t1, t2, t3) when (b.FStar_Ident.str = s) -> begin
Some (())
end
| _86_288 -> begin
None
end)))
in (FStar_All.pipe_right _179_344 FStar_Option.isSome)))


let lookup_lid : env_t  ->  FStar_Ident.lident  ->  (Prims.string * FStar_SMTEncoding_Term.term Prims.option * FStar_SMTEncoding_Term.term Prims.option) = (fun env a -> (match ((try_lookup_lid env a)) with
| None -> begin
(let _179_350 = (let _179_349 = (FStar_Syntax_Print.lid_to_string a)
in (FStar_Util.format1 "Name not found: %s" _179_349))
in (FStar_All.failwith _179_350))
end
| Some (s) -> begin
s
end))


let push_free_var : env_t  ->  FStar_Ident.lident  ->  Prims.string  ->  FStar_SMTEncoding_Term.term Prims.option  ->  env_t = (fun env x fname ftok -> (

let _86_298 = env
in {bindings = (Binding_fvar (((x), (fname), (ftok), (None))))::env.bindings; depth = _86_298.depth; tcenv = _86_298.tcenv; warn = _86_298.warn; cache = _86_298.cache; nolabels = _86_298.nolabels; use_zfuel_name = _86_298.use_zfuel_name; encode_non_total_function_typ = _86_298.encode_non_total_function_typ}))


let push_zfuel_name : env_t  ->  FStar_Ident.lident  ->  Prims.string  ->  env_t = (fun env x f -> (

let _86_307 = (lookup_lid env x)
in (match (_86_307) with
| (t1, t2, _86_306) -> begin
(

let t3 = (let _179_367 = (let _179_366 = (let _179_365 = (FStar_SMTEncoding_Term.mkApp (("ZFuel"), ([])))
in (_179_365)::[])
in ((f), (_179_366)))
in (FStar_SMTEncoding_Term.mkApp _179_367))
in (

let _86_309 = env
in {bindings = (Binding_fvar (((x), (t1), (t2), (Some (t3)))))::env.bindings; depth = _86_309.depth; tcenv = _86_309.tcenv; warn = _86_309.warn; cache = _86_309.cache; nolabels = _86_309.nolabels; use_zfuel_name = _86_309.use_zfuel_name; encode_non_total_function_typ = _86_309.encode_non_total_function_typ}))
end)))


let try_lookup_free_var : env_t  ->  FStar_Ident.lident  ->  FStar_SMTEncoding_Term.term Prims.option = (fun env l -> (match ((try_lookup_lid env l)) with
| None -> begin
None
end
| Some (name, sym, zf_opt) -> begin
(match (zf_opt) with
| Some (f) when env.use_zfuel_name -> begin
Some (f)
end
| _86_322 -> begin
(match (sym) with
| Some (t) -> begin
(match (t.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.App (_86_326, (fuel)::[]) -> begin
if (let _179_373 = (let _179_372 = (FStar_SMTEncoding_Term.fv_of_term fuel)
in (FStar_All.pipe_right _179_372 Prims.fst))
in (FStar_Util.starts_with _179_373 "fuel")) then begin
(let _179_376 = (let _179_375 = (FStar_SMTEncoding_Term.mkFreeV ((name), (FStar_SMTEncoding_Term.Term_sort)))
in (FStar_SMTEncoding_Term.mk_ApplyTF _179_375 fuel))
in (FStar_All.pipe_left (fun _179_374 -> Some (_179_374)) _179_376))
end else begin
Some (t)
end
end
| _86_332 -> begin
Some (t)
end)
end
| _86_334 -> begin
None
end)
end)
end))


let lookup_free_var = (fun env a -> (match ((try_lookup_free_var env a.FStar_Syntax_Syntax.v)) with
| Some (t) -> begin
t
end
| None -> begin
(let _179_380 = (let _179_379 = (FStar_Syntax_Print.lid_to_string a.FStar_Syntax_Syntax.v)
in (FStar_Util.format1 "Name not found: %s" _179_379))
in (FStar_All.failwith _179_380))
end))


let lookup_free_var_name = (fun env a -> (

let _86_347 = (lookup_lid env a.FStar_Syntax_Syntax.v)
in (match (_86_347) with
| (x, _86_344, _86_346) -> begin
x
end)))


let lookup_free_var_sym = (fun env a -> (

let _86_353 = (lookup_lid env a.FStar_Syntax_Syntax.v)
in (match (_86_353) with
| (name, sym, zf_opt) -> begin
(match (zf_opt) with
| Some ({FStar_SMTEncoding_Term.tm = FStar_SMTEncoding_Term.App (g, zf); FStar_SMTEncoding_Term.hash = _86_357; FStar_SMTEncoding_Term.freevars = _86_355}) when env.use_zfuel_name -> begin
((g), (zf))
end
| _86_365 -> begin
(match (sym) with
| None -> begin
((FStar_SMTEncoding_Term.Var (name)), ([]))
end
| Some (sym) -> begin
(match (sym.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.App (g, (fuel)::[]) -> begin
((g), ((fuel)::[]))
end
| _86_375 -> begin
((FStar_SMTEncoding_Term.Var (name)), ([]))
end)
end)
end)
end)))


let tok_of_name : env_t  ->  Prims.string  ->  FStar_SMTEncoding_Term.term Prims.option = (fun env nm -> (FStar_Util.find_map env.bindings (fun _86_6 -> (match (_86_6) with
| Binding_fvar (_86_380, nm', tok, _86_384) when (nm = nm') -> begin
tok
end
| _86_388 -> begin
None
end))))


let mkForall_fuel' = (fun n _86_393 -> (match (_86_393) with
| (pats, vars, body) -> begin
(

let fallback = (fun _86_395 -> (match (()) with
| () -> begin
(FStar_SMTEncoding_Term.mkForall ((pats), (vars), (body)))
end))
in if (FStar_Options.unthrottle_inductives ()) then begin
(fallback ())
end else begin
(

let _86_398 = (fresh_fvar "f" FStar_SMTEncoding_Term.Fuel_sort)
in (match (_86_398) with
| (fsym, fterm) -> begin
(

let add_fuel = (fun tms -> (FStar_All.pipe_right tms (FStar_List.map (fun p -> (match (p.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Var ("HasType"), args) -> begin
(FStar_SMTEncoding_Term.mkApp (("HasTypeFuel"), ((fterm)::args)))
end
| _86_408 -> begin
p
end)))))
in (

let pats = (FStar_List.map add_fuel pats)
in (

let body = (match (body.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Imp, (guard)::(body')::[]) -> begin
(

let guard = (match (guard.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.And, guards) -> begin
(let _179_397 = (add_fuel guards)
in (FStar_SMTEncoding_Term.mk_and_l _179_397))
end
| _86_421 -> begin
(let _179_398 = (add_fuel ((guard)::[]))
in (FStar_All.pipe_right _179_398 FStar_List.hd))
end)
in (FStar_SMTEncoding_Term.mkImp ((guard), (body'))))
end
| _86_424 -> begin
body
end)
in (

let vars = (((fsym), (FStar_SMTEncoding_Term.Fuel_sort)))::vars
in (FStar_SMTEncoding_Term.mkForall ((pats), (vars), (body)))))))
end))
end)
end))


let mkForall_fuel : (FStar_SMTEncoding_Term.pat Prims.list Prims.list * FStar_SMTEncoding_Term.fvs * FStar_SMTEncoding_Term.term)  ->  FStar_SMTEncoding_Term.term = (mkForall_fuel' (Prims.parse_int "1"))


let head_normal : env_t  ->  FStar_Syntax_Syntax.term  ->  Prims.bool = (fun env t -> (

let t = (FStar_Syntax_Util.unmeta t)
in (match (t.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.Tm_arrow (_)) | (FStar_Syntax_Syntax.Tm_refine (_)) | (FStar_Syntax_Syntax.Tm_bvar (_)) | (FStar_Syntax_Syntax.Tm_uvar (_)) | (FStar_Syntax_Syntax.Tm_abs (_)) | (FStar_Syntax_Syntax.Tm_constant (_)) -> begin
true
end
| (FStar_Syntax_Syntax.Tm_fvar (fv)) | (FStar_Syntax_Syntax.Tm_app ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar (fv); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, _)) -> begin
(let _179_404 = (FStar_TypeChecker_Env.lookup_definition FStar_TypeChecker_Env.OnlyInline env.tcenv fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)
in (FStar_All.pipe_right _179_404 FStar_Option.isNone))
end
| _86_463 -> begin
false
end)))


let head_redex : env_t  ->  FStar_Syntax_Syntax.term  ->  Prims.bool = (fun env t -> (match ((let _179_409 = (FStar_Syntax_Util.un_uinst t)
in _179_409.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_abs (_86_467) -> begin
true
end
| FStar_Syntax_Syntax.Tm_fvar (fv) -> begin
(let _179_410 = (FStar_TypeChecker_Env.lookup_definition FStar_TypeChecker_Env.OnlyInline env.tcenv fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)
in (FStar_All.pipe_right _179_410 FStar_Option.isSome))
end
| _86_472 -> begin
false
end))


let whnf : env_t  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun env t -> if (head_normal env t) then begin
t
end else begin
(FStar_TypeChecker_Normalize.normalize ((FStar_TypeChecker_Normalize.Beta)::(FStar_TypeChecker_Normalize.WHNF)::(FStar_TypeChecker_Normalize.Inline)::(FStar_TypeChecker_Normalize.EraseUniverses)::[]) env.tcenv t)
end)


let norm : env_t  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun env t -> (FStar_TypeChecker_Normalize.normalize ((FStar_TypeChecker_Normalize.Beta)::(FStar_TypeChecker_Normalize.Inline)::(FStar_TypeChecker_Normalize.EraseUniverses)::[]) env.tcenv t))


let trivial_post : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun t -> (let _179_423 = (let _179_421 = (FStar_Syntax_Syntax.null_binder t)
in (_179_421)::[])
in (let _179_422 = (FStar_Syntax_Syntax.fvar FStar_Syntax_Const.true_lid FStar_Syntax_Syntax.Delta_constant None)
in (FStar_Syntax_Util.abs _179_423 _179_422 None))))


let mk_Apply : FStar_SMTEncoding_Term.term  ->  (Prims.string * FStar_SMTEncoding_Term.sort) Prims.list  ->  FStar_SMTEncoding_Term.term = (fun e vars -> (FStar_All.pipe_right vars (FStar_List.fold_left (fun out var -> (match ((Prims.snd var)) with
| FStar_SMTEncoding_Term.Fuel_sort -> begin
(let _179_430 = (FStar_SMTEncoding_Term.mkFreeV var)
in (FStar_SMTEncoding_Term.mk_ApplyTF out _179_430))
end
| s -> begin
(

let _86_484 = ()
in (let _179_431 = (FStar_SMTEncoding_Term.mkFreeV var)
in (FStar_SMTEncoding_Term.mk_ApplyTT out _179_431)))
end)) e)))


let mk_Apply_args : FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term Prims.list  ->  FStar_SMTEncoding_Term.term = (fun e args -> (FStar_All.pipe_right args (FStar_List.fold_left FStar_SMTEncoding_Term.mk_ApplyTT e)))


let is_app : FStar_SMTEncoding_Term.op  ->  Prims.bool = (fun _86_7 -> (match (_86_7) with
| (FStar_SMTEncoding_Term.Var ("ApplyTT")) | (FStar_SMTEncoding_Term.Var ("ApplyTF")) -> begin
true
end
| _86_494 -> begin
false
end))


let is_eta : env_t  ->  FStar_SMTEncoding_Term.fv Prims.list  ->  FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term Prims.option = (fun env vars t -> (

let rec aux = (fun t xs -> (match (((t.FStar_SMTEncoding_Term.tm), (xs))) with
| (FStar_SMTEncoding_Term.App (app, (f)::({FStar_SMTEncoding_Term.tm = FStar_SMTEncoding_Term.FreeV (y); FStar_SMTEncoding_Term.hash = _86_505; FStar_SMTEncoding_Term.freevars = _86_503})::[]), (x)::xs) when ((is_app app) && (FStar_SMTEncoding_Term.fv_eq x y)) -> begin
(aux f xs)
end
| (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Var (f), args), _86_523) -> begin
if (((FStar_List.length args) = (FStar_List.length vars)) && (FStar_List.forall2 (fun a v -> (match (a.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.FreeV (fv) -> begin
(FStar_SMTEncoding_Term.fv_eq fv v)
end
| _86_530 -> begin
false
end)) args vars)) then begin
(tok_of_name env f)
end else begin
None
end
end
| (_86_532, []) -> begin
(

let fvs = (FStar_SMTEncoding_Term.free_variables t)
in if (FStar_All.pipe_right fvs (FStar_List.for_all (fun fv -> (not ((FStar_Util.for_some (FStar_SMTEncoding_Term.fv_eq fv) vars)))))) then begin
Some (t)
end else begin
None
end)
end
| _86_538 -> begin
None
end))
in (aux t (FStar_List.rev vars))))


type label =
(FStar_SMTEncoding_Term.fv * Prims.string * FStar_Range.range)


type labels =
label Prims.list


type pattern =
{pat_vars : (FStar_Syntax_Syntax.bv * FStar_SMTEncoding_Term.fv) Prims.list; pat_term : Prims.unit  ->  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t); guard : FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term; projections : FStar_SMTEncoding_Term.term  ->  (FStar_Syntax_Syntax.bv * FStar_SMTEncoding_Term.term) Prims.list}


let is_Mkpattern : pattern  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkpattern"))))


exception Let_rec_unencodeable


let is_Let_rec_unencodeable = (fun _discr_ -> (match (_discr_) with
| Let_rec_unencodeable (_) -> begin
true
end
| _ -> begin
false
end))


let encode_const : FStar_Const.sconst  ->  FStar_SMTEncoding_Term.term = (fun _86_8 -> (match (_86_8) with
| FStar_Const.Const_unit -> begin
FStar_SMTEncoding_Term.mk_Term_unit
end
| FStar_Const.Const_bool (true) -> begin
(FStar_SMTEncoding_Term.boxBool FStar_SMTEncoding_Term.mkTrue)
end
| FStar_Const.Const_bool (false) -> begin
(FStar_SMTEncoding_Term.boxBool FStar_SMTEncoding_Term.mkFalse)
end
| FStar_Const.Const_char (c) -> begin
(let _179_488 = (let _179_487 = (let _179_486 = (let _179_485 = (FStar_SMTEncoding_Term.mkInteger' (FStar_Util.int_of_char c))
in (FStar_SMTEncoding_Term.boxInt _179_485))
in (_179_486)::[])
in (("FStar.Char.Char"), (_179_487)))
in (FStar_SMTEncoding_Term.mkApp _179_488))
end
| FStar_Const.Const_int (i, None) -> begin
(let _179_489 = (FStar_SMTEncoding_Term.mkInteger i)
in (FStar_SMTEncoding_Term.boxInt _179_489))
end
| FStar_Const.Const_int (i, Some (_86_558)) -> begin
(FStar_All.failwith "Machine integers should be desugared")
end
| FStar_Const.Const_string (bytes, _86_564) -> begin
(let _179_490 = (FStar_All.pipe_left FStar_Util.string_of_bytes bytes)
in (varops.string_const _179_490))
end
| FStar_Const.Const_range (r) -> begin
FStar_SMTEncoding_Term.mk_Range_const
end
| FStar_Const.Const_effect -> begin
FStar_SMTEncoding_Term.mk_Term_type
end
| c -> begin
(let _179_492 = (let _179_491 = (FStar_Syntax_Print.const_to_string c)
in (FStar_Util.format1 "Unhandled constant: %s" _179_491))
in (FStar_All.failwith _179_492))
end))


let as_function_typ : env_t  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  FStar_Syntax_Syntax.term = (fun env t0 -> (

let rec aux = (fun norm t -> (

let t = (FStar_Syntax_Subst.compress t)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_arrow (_86_578) -> begin
t
end
| FStar_Syntax_Syntax.Tm_refine (_86_581) -> begin
(let _179_501 = (FStar_Syntax_Util.unrefine t)
in (aux true _179_501))
end
| _86_584 -> begin
if norm then begin
(let _179_502 = (whnf env t)
in (aux false _179_502))
end else begin
(let _179_505 = (let _179_504 = (FStar_Range.string_of_range t0.FStar_Syntax_Syntax.pos)
in (let _179_503 = (FStar_Syntax_Print.term_to_string t0)
in (FStar_Util.format2 "(%s) Expected a function typ; got %s" _179_504 _179_503)))
in (FStar_All.failwith _179_505))
end
end)))
in (aux true t0)))


let curried_arrow_formals_comp : FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.comp) = (fun k -> (

let k = (FStar_Syntax_Subst.compress k)
in (match (k.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_arrow (bs, c) -> begin
(FStar_Syntax_Subst.open_comp bs c)
end
| _86_592 -> begin
(let _179_508 = (FStar_Syntax_Syntax.mk_Total k)
in (([]), (_179_508)))
end)))


let rec encode_binders : FStar_SMTEncoding_Term.term Prims.option  ->  FStar_Syntax_Syntax.binders  ->  env_t  ->  (FStar_SMTEncoding_Term.fv Prims.list * FStar_SMTEncoding_Term.term Prims.list * env_t * FStar_SMTEncoding_Term.decls_t * FStar_Syntax_Syntax.bv Prims.list) = (fun fuel_opt bs env -> (

let _86_596 = if (FStar_TypeChecker_Env.debug env.tcenv FStar_Options.Low) then begin
(let _179_556 = (FStar_Syntax_Print.binders_to_string ", " bs)
in (FStar_Util.print1 "Encoding binders %s\n" _179_556))
end else begin
()
end
in (

let _86_624 = (FStar_All.pipe_right bs (FStar_List.fold_left (fun _86_603 b -> (match (_86_603) with
| (vars, guards, env, decls, names) -> begin
(

let _86_618 = (

let x = (unmangle (Prims.fst b))
in (

let _86_609 = (gen_term_var env x)
in (match (_86_609) with
| (xxsym, xx, env') -> begin
(

let _86_612 = (let _179_559 = (norm env x.FStar_Syntax_Syntax.sort)
in (encode_term_pred fuel_opt _179_559 env xx))
in (match (_86_612) with
| (guard_x_t, decls') -> begin
((((xxsym), (FStar_SMTEncoding_Term.Term_sort))), (guard_x_t), (env'), (decls'), (x))
end))
end)))
in (match (_86_618) with
| (v, g, env, decls', n) -> begin
(((v)::vars), ((g)::guards), (env), ((FStar_List.append decls decls')), ((n)::names))
end))
end)) (([]), ([]), (env), ([]), ([]))))
in (match (_86_624) with
| (vars, guards, env, decls, names) -> begin
(((FStar_List.rev vars)), ((FStar_List.rev guards)), (env), (decls), ((FStar_List.rev names)))
end))))
and encode_term_pred : FStar_SMTEncoding_Term.term Prims.option  ->  FStar_Syntax_Syntax.typ  ->  env_t  ->  FStar_SMTEncoding_Term.term  ->  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t) = (fun fuel_opt t env e -> (

let _86_631 = (encode_term t env)
in (match (_86_631) with
| (t, decls) -> begin
(let _179_564 = (FStar_SMTEncoding_Term.mk_HasTypeWithFuel fuel_opt e t)
in ((_179_564), (decls)))
end)))
and encode_term_pred' : FStar_SMTEncoding_Term.term Prims.option  ->  FStar_Syntax_Syntax.typ  ->  env_t  ->  FStar_SMTEncoding_Term.term  ->  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t) = (fun fuel_opt t env e -> (

let _86_638 = (encode_term t env)
in (match (_86_638) with
| (t, decls) -> begin
(match (fuel_opt) with
| None -> begin
(let _179_569 = (FStar_SMTEncoding_Term.mk_HasTypeZ e t)
in ((_179_569), (decls)))
end
| Some (f) -> begin
(let _179_570 = (FStar_SMTEncoding_Term.mk_HasTypeFuel f e t)
in ((_179_570), (decls)))
end)
end)))
and encode_term : FStar_Syntax_Syntax.typ  ->  env_t  ->  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t) = (fun t env -> (

let t0 = (FStar_Syntax_Subst.compress t)
in (

let _86_645 = if (FStar_All.pipe_left (FStar_TypeChecker_Env.debug env.tcenv) (FStar_Options.Other ("SMTEncoding"))) then begin
(let _179_575 = (FStar_Syntax_Print.tag_of_term t)
in (let _179_574 = (FStar_Syntax_Print.tag_of_term t0)
in (let _179_573 = (FStar_Syntax_Print.term_to_string t0)
in (FStar_Util.print3 "(%s) (%s)   %s\n" _179_575 _179_574 _179_573))))
end else begin
()
end
in (match (t0.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.Tm_delayed (_)) | (FStar_Syntax_Syntax.Tm_unknown) -> begin
(let _179_580 = (let _179_579 = (FStar_All.pipe_left FStar_Range.string_of_range t.FStar_Syntax_Syntax.pos)
in (let _179_578 = (FStar_Syntax_Print.tag_of_term t0)
in (let _179_577 = (FStar_Syntax_Print.term_to_string t0)
in (let _179_576 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.format4 "(%s) Impossible: %s\n%s\n%s\n" _179_579 _179_578 _179_577 _179_576)))))
in (FStar_All.failwith _179_580))
end
| FStar_Syntax_Syntax.Tm_bvar (x) -> begin
(let _179_582 = (let _179_581 = (FStar_Syntax_Print.bv_to_string x)
in (FStar_Util.format1 "Impossible: locally nameless; got %s" _179_581))
in (FStar_All.failwith _179_582))
end
| FStar_Syntax_Syntax.Tm_ascribed (t, k, _86_656) -> begin
(encode_term t env)
end
| FStar_Syntax_Syntax.Tm_meta (t, _86_661) -> begin
(encode_term t env)
end
| FStar_Syntax_Syntax.Tm_name (x) -> begin
(

let t = (lookup_term_var env x)
in ((t), ([])))
end
| FStar_Syntax_Syntax.Tm_fvar (v) -> begin
(let _179_583 = (lookup_free_var env v.FStar_Syntax_Syntax.fv_name)
in ((_179_583), ([])))
end
| FStar_Syntax_Syntax.Tm_type (_86_670) -> begin
((FStar_SMTEncoding_Term.mk_Term_type), ([]))
end
| FStar_Syntax_Syntax.Tm_uinst (t, _86_674) -> begin
(encode_term t env)
end
| FStar_Syntax_Syntax.Tm_constant (c) -> begin
(let _179_584 = (encode_const c)
in ((_179_584), ([])))
end
| FStar_Syntax_Syntax.Tm_arrow (binders, c) -> begin
(

let _86_685 = (FStar_Syntax_Subst.open_comp binders c)
in (match (_86_685) with
| (binders, res) -> begin
if ((env.encode_non_total_function_typ && (FStar_Syntax_Util.is_pure_or_ghost_comp res)) || (FStar_Syntax_Util.is_tot_or_gtot_comp res)) then begin
(

let _86_692 = (encode_binders None binders env)
in (match (_86_692) with
| (vars, guards, env', decls, _86_691) -> begin
(

let fsym = (let _179_585 = (varops.fresh "f")
in ((_179_585), (FStar_SMTEncoding_Term.Term_sort)))
in (

let f = (FStar_SMTEncoding_Term.mkFreeV fsym)
in (

let app = (mk_Apply f vars)
in (

let _86_700 = (FStar_TypeChecker_Util.pure_or_ghost_pre_and_post (

let _86_696 = env.tcenv
in {FStar_TypeChecker_Env.solver = _86_696.FStar_TypeChecker_Env.solver; FStar_TypeChecker_Env.range = _86_696.FStar_TypeChecker_Env.range; FStar_TypeChecker_Env.curmodule = _86_696.FStar_TypeChecker_Env.curmodule; FStar_TypeChecker_Env.gamma = _86_696.FStar_TypeChecker_Env.gamma; FStar_TypeChecker_Env.gamma_cache = _86_696.FStar_TypeChecker_Env.gamma_cache; FStar_TypeChecker_Env.modules = _86_696.FStar_TypeChecker_Env.modules; FStar_TypeChecker_Env.expected_typ = _86_696.FStar_TypeChecker_Env.expected_typ; FStar_TypeChecker_Env.sigtab = _86_696.FStar_TypeChecker_Env.sigtab; FStar_TypeChecker_Env.is_pattern = _86_696.FStar_TypeChecker_Env.is_pattern; FStar_TypeChecker_Env.instantiate_imp = _86_696.FStar_TypeChecker_Env.instantiate_imp; FStar_TypeChecker_Env.effects = _86_696.FStar_TypeChecker_Env.effects; FStar_TypeChecker_Env.generalize = _86_696.FStar_TypeChecker_Env.generalize; FStar_TypeChecker_Env.letrecs = _86_696.FStar_TypeChecker_Env.letrecs; FStar_TypeChecker_Env.top_level = _86_696.FStar_TypeChecker_Env.top_level; FStar_TypeChecker_Env.check_uvars = _86_696.FStar_TypeChecker_Env.check_uvars; FStar_TypeChecker_Env.use_eq = _86_696.FStar_TypeChecker_Env.use_eq; FStar_TypeChecker_Env.is_iface = _86_696.FStar_TypeChecker_Env.is_iface; FStar_TypeChecker_Env.admit = _86_696.FStar_TypeChecker_Env.admit; FStar_TypeChecker_Env.lax = true; FStar_TypeChecker_Env.type_of = _86_696.FStar_TypeChecker_Env.type_of; FStar_TypeChecker_Env.universe_of = _86_696.FStar_TypeChecker_Env.universe_of; FStar_TypeChecker_Env.use_bv_sorts = _86_696.FStar_TypeChecker_Env.use_bv_sorts; FStar_TypeChecker_Env.qname_and_index = _86_696.FStar_TypeChecker_Env.qname_and_index}) res)
in (match (_86_700) with
| (pre_opt, res_t) -> begin
(

let _86_703 = (encode_term_pred None res_t env' app)
in (match (_86_703) with
| (res_pred, decls') -> begin
(

let _86_712 = (match (pre_opt) with
| None -> begin
(let _179_586 = (FStar_SMTEncoding_Term.mk_and_l guards)
in ((_179_586), ([])))
end
| Some (pre) -> begin
(

let _86_709 = (encode_formula pre env')
in (match (_86_709) with
| (guard, decls0) -> begin
(let _179_587 = (FStar_SMTEncoding_Term.mk_and_l ((guard)::guards))
in ((_179_587), (decls0)))
end))
end)
in (match (_86_712) with
| (guards, guard_decls) -> begin
(

let t_interp = (let _179_589 = (let _179_588 = (FStar_SMTEncoding_Term.mkImp ((guards), (res_pred)))
in ((((app)::[])::[]), (vars), (_179_588)))
in (FStar_SMTEncoding_Term.mkForall _179_589))
in (

let cvars = (let _179_591 = (FStar_SMTEncoding_Term.free_variables t_interp)
in (FStar_All.pipe_right _179_591 (FStar_List.filter (fun _86_717 -> (match (_86_717) with
| (x, _86_716) -> begin
(x <> (Prims.fst fsym))
end)))))
in (

let tkey = (FStar_SMTEncoding_Term.mkForall (([]), ((fsym)::cvars), (t_interp)))
in (match ((FStar_Util.smap_try_find env.cache tkey.FStar_SMTEncoding_Term.hash)) with
| Some (t', sorts, _86_723) -> begin
(let _179_594 = (let _179_593 = (let _179_592 = (FStar_All.pipe_right cvars (FStar_List.map FStar_SMTEncoding_Term.mkFreeV))
in ((t'), (_179_592)))
in (FStar_SMTEncoding_Term.mkApp _179_593))
in ((_179_594), ([])))
end
| None -> begin
(

let tsym = (let _179_596 = (let _179_595 = (FStar_Util.digest_of_string tkey.FStar_SMTEncoding_Term.hash)
in (Prims.strcat "Tm_arrow_" _179_595))
in (varops.mk_unique _179_596))
in (

let cvar_sorts = (FStar_List.map Prims.snd cvars)
in (

let caption = if (FStar_Options.log_queries ()) then begin
(let _179_597 = (FStar_TypeChecker_Normalize.term_to_string env.tcenv t0)
in Some (_179_597))
end else begin
None
end
in (

let tdecl = FStar_SMTEncoding_Term.DeclFun (((tsym), (cvar_sorts), (FStar_SMTEncoding_Term.Term_sort), (caption)))
in (

let t = (let _179_599 = (let _179_598 = (FStar_List.map FStar_SMTEncoding_Term.mkFreeV cvars)
in ((tsym), (_179_598)))
in (FStar_SMTEncoding_Term.mkApp _179_599))
in (

let t_has_kind = (FStar_SMTEncoding_Term.mk_HasType t FStar_SMTEncoding_Term.mk_Term_type)
in (

let k_assumption = (

let a_name = Some ((Prims.strcat "kinding_" tsym))
in (let _179_601 = (let _179_600 = (FStar_SMTEncoding_Term.mkForall ((((t_has_kind)::[])::[]), (cvars), (t_has_kind)))
in ((_179_600), (a_name), (a_name)))
in FStar_SMTEncoding_Term.Assume (_179_601)))
in (

let f_has_t = (FStar_SMTEncoding_Term.mk_HasType f t)
in (

let f_has_t_z = (FStar_SMTEncoding_Term.mk_HasTypeZ f t)
in (

let pre_typing = (

let a_name = Some ((Prims.strcat "pre_typing_" tsym))
in (let _179_608 = (let _179_607 = (let _179_606 = (let _179_605 = (let _179_604 = (let _179_603 = (let _179_602 = (FStar_SMTEncoding_Term.mk_PreType f)
in (FStar_SMTEncoding_Term.mk_tester "Tm_arrow" _179_602))
in ((f_has_t), (_179_603)))
in (FStar_SMTEncoding_Term.mkImp _179_604))
in ((((f_has_t)::[])::[]), ((fsym)::cvars), (_179_605)))
in (mkForall_fuel _179_606))
in ((_179_607), (Some ("pre-typing for functions")), (a_name)))
in FStar_SMTEncoding_Term.Assume (_179_608)))
in (

let t_interp = (

let a_name = Some ((Prims.strcat "interpretation_" tsym))
in (let _179_612 = (let _179_611 = (let _179_610 = (let _179_609 = (FStar_SMTEncoding_Term.mkIff ((f_has_t_z), (t_interp)))
in ((((f_has_t_z)::[])::[]), ((fsym)::cvars), (_179_609)))
in (FStar_SMTEncoding_Term.mkForall _179_610))
in ((_179_611), (a_name), (a_name)))
in FStar_SMTEncoding_Term.Assume (_179_612)))
in (

let t_decls = (FStar_List.append ((tdecl)::decls) (FStar_List.append decls' (FStar_List.append guard_decls ((k_assumption)::(pre_typing)::(t_interp)::[]))))
in (

let _86_742 = (FStar_Util.smap_add env.cache tkey.FStar_SMTEncoding_Term.hash ((tsym), (cvar_sorts), (t_decls)))
in ((t), (t_decls)))))))))))))))
end))))
end))
end))
end)))))
end))
end else begin
(

let tsym = (varops.fresh "Non_total_Tm_arrow")
in (

let tdecl = FStar_SMTEncoding_Term.DeclFun (((tsym), ([]), (FStar_SMTEncoding_Term.Term_sort), (None)))
in (

let t = (FStar_SMTEncoding_Term.mkApp ((tsym), ([])))
in (

let t_kinding = (

let a_name = Some ((Prims.strcat "non_total_function_typing_" tsym))
in (let _179_614 = (let _179_613 = (FStar_SMTEncoding_Term.mk_HasType t FStar_SMTEncoding_Term.mk_Term_type)
in ((_179_613), (Some ("Typing for non-total arrows")), (a_name)))
in FStar_SMTEncoding_Term.Assume (_179_614)))
in (

let fsym = (("f"), (FStar_SMTEncoding_Term.Term_sort))
in (

let f = (FStar_SMTEncoding_Term.mkFreeV fsym)
in (

let f_has_t = (FStar_SMTEncoding_Term.mk_HasType f t)
in (

let t_interp = (

let a_name = Some ((Prims.strcat "pre_typing_" tsym))
in (let _179_621 = (let _179_620 = (let _179_619 = (let _179_618 = (let _179_617 = (let _179_616 = (let _179_615 = (FStar_SMTEncoding_Term.mk_PreType f)
in (FStar_SMTEncoding_Term.mk_tester "Tm_arrow" _179_615))
in ((f_has_t), (_179_616)))
in (FStar_SMTEncoding_Term.mkImp _179_617))
in ((((f_has_t)::[])::[]), ((fsym)::[]), (_179_618)))
in (mkForall_fuel _179_619))
in ((_179_620), (a_name), (a_name)))
in FStar_SMTEncoding_Term.Assume (_179_621)))
in ((t), ((tdecl)::(t_kinding)::(t_interp)::[]))))))))))
end
end))
end
| FStar_Syntax_Syntax.Tm_refine (_86_755) -> begin
(

let _86_775 = (match ((FStar_TypeChecker_Normalize.normalize_refinement ((FStar_TypeChecker_Normalize.WHNF)::(FStar_TypeChecker_Normalize.EraseUniverses)::[]) env.tcenv t0)) with
| {FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_refine (x, f); FStar_Syntax_Syntax.tk = _86_762; FStar_Syntax_Syntax.pos = _86_760; FStar_Syntax_Syntax.vars = _86_758} -> begin
(

let _86_770 = (FStar_Syntax_Subst.open_term ((((x), (None)))::[]) f)
in (match (_86_770) with
| (b, f) -> begin
(let _179_623 = (let _179_622 = (FStar_List.hd b)
in (Prims.fst _179_622))
in ((_179_623), (f)))
end))
end
| _86_772 -> begin
(FStar_All.failwith "impossible")
end)
in (match (_86_775) with
| (x, f) -> begin
(

let _86_778 = (encode_term x.FStar_Syntax_Syntax.sort env)
in (match (_86_778) with
| (base_t, decls) -> begin
(

let _86_782 = (gen_term_var env x)
in (match (_86_782) with
| (x, xtm, env') -> begin
(

let _86_785 = (encode_formula f env')
in (match (_86_785) with
| (refinement, decls') -> begin
(

let _86_788 = (fresh_fvar "f" FStar_SMTEncoding_Term.Fuel_sort)
in (match (_86_788) with
| (fsym, fterm) -> begin
(

let encoding = (let _179_625 = (let _179_624 = (FStar_SMTEncoding_Term.mk_HasTypeWithFuel (Some (fterm)) xtm base_t)
in ((_179_624), (refinement)))
in (FStar_SMTEncoding_Term.mkAnd _179_625))
in (

let cvars = (let _179_627 = (FStar_SMTEncoding_Term.free_variables encoding)
in (FStar_All.pipe_right _179_627 (FStar_List.filter (fun _86_793 -> (match (_86_793) with
| (y, _86_792) -> begin
((y <> x) && (y <> fsym))
end)))))
in (

let xfv = ((x), (FStar_SMTEncoding_Term.Term_sort))
in (

let ffv = ((fsym), (FStar_SMTEncoding_Term.Fuel_sort))
in (

let tkey = (FStar_SMTEncoding_Term.mkForall (([]), ((ffv)::(xfv)::cvars), (encoding)))
in (match ((FStar_Util.smap_try_find env.cache tkey.FStar_SMTEncoding_Term.hash)) with
| Some (t, _86_800, _86_802) -> begin
(let _179_630 = (let _179_629 = (let _179_628 = (FStar_All.pipe_right cvars (FStar_List.map FStar_SMTEncoding_Term.mkFreeV))
in ((t), (_179_628)))
in (FStar_SMTEncoding_Term.mkApp _179_629))
in ((_179_630), ([])))
end
| None -> begin
(

let tsym = (let _179_632 = (let _179_631 = (FStar_Util.digest_of_string tkey.FStar_SMTEncoding_Term.hash)
in (Prims.strcat "Tm_refine_" _179_631))
in (varops.mk_unique _179_632))
in (

let cvar_sorts = (FStar_List.map Prims.snd cvars)
in (

let tdecl = FStar_SMTEncoding_Term.DeclFun (((tsym), (cvar_sorts), (FStar_SMTEncoding_Term.Term_sort), (None)))
in (

let t = (let _179_634 = (let _179_633 = (FStar_List.map FStar_SMTEncoding_Term.mkFreeV cvars)
in ((tsym), (_179_633)))
in (FStar_SMTEncoding_Term.mkApp _179_634))
in (

let x_has_t = (FStar_SMTEncoding_Term.mk_HasTypeWithFuel (Some (fterm)) xtm t)
in (

let t_has_kind = (FStar_SMTEncoding_Term.mk_HasType t FStar_SMTEncoding_Term.mk_Term_type)
in (

let t_haseq_base = (FStar_SMTEncoding_Term.mk_haseq base_t)
in (

let t_haseq_ref = (FStar_SMTEncoding_Term.mk_haseq t)
in (

let t_haseq = (let _179_638 = (let _179_637 = (let _179_636 = (let _179_635 = (FStar_SMTEncoding_Term.mkIff ((t_haseq_ref), (t_haseq_base)))
in ((((t_haseq_ref)::[])::[]), (cvars), (_179_635)))
in (FStar_SMTEncoding_Term.mkForall _179_636))
in ((_179_637), (Some ((Prims.strcat "haseq for " tsym))), (Some ((Prims.strcat "haseq" tsym)))))
in FStar_SMTEncoding_Term.Assume (_179_638))
in (

let t_kinding = (let _179_640 = (let _179_639 = (FStar_SMTEncoding_Term.mkForall ((((t_has_kind)::[])::[]), (cvars), (t_has_kind)))
in ((_179_639), (Some ("refinement kinding")), (Some ((Prims.strcat "refinement_kinding_" tsym)))))
in FStar_SMTEncoding_Term.Assume (_179_640))
in (

let t_interp = (let _179_646 = (let _179_645 = (let _179_642 = (let _179_641 = (FStar_SMTEncoding_Term.mkIff ((x_has_t), (encoding)))
in ((((x_has_t)::[])::[]), ((ffv)::(xfv)::cvars), (_179_641)))
in (FStar_SMTEncoding_Term.mkForall _179_642))
in (let _179_644 = (let _179_643 = (FStar_Syntax_Print.term_to_string t0)
in Some (_179_643))
in ((_179_645), (_179_644), (Some ((Prims.strcat "refinement_interpretation_" tsym))))))
in FStar_SMTEncoding_Term.Assume (_179_646))
in (

let t_decls = (FStar_List.append decls (FStar_List.append decls' ((tdecl)::(t_kinding)::(t_interp)::(t_haseq)::[])))
in (

let _86_818 = (FStar_Util.smap_add env.cache tkey.FStar_SMTEncoding_Term.hash ((tsym), (cvar_sorts), (t_decls)))
in ((t), (t_decls)))))))))))))))
end))))))
end))
end))
end))
end))
end))
end
| FStar_Syntax_Syntax.Tm_uvar (uv, k) -> begin
(

let ttm = (let _179_647 = (FStar_Unionfind.uvar_id uv)
in (FStar_SMTEncoding_Term.mk_Term_uvar _179_647))
in (

let _86_827 = (encode_term_pred None k env ttm)
in (match (_86_827) with
| (t_has_k, decls) -> begin
(

let d = (let _179_653 = (let _179_652 = (let _179_651 = (let _179_650 = (let _179_649 = (let _179_648 = (FStar_Unionfind.uvar_id uv)
in (FStar_All.pipe_left FStar_Util.string_of_int _179_648))
in (FStar_Util.format1 "uvar_typing_%s" _179_649))
in (varops.mk_unique _179_650))
in Some (_179_651))
in ((t_has_k), (Some ("Uvar typing")), (_179_652)))
in FStar_SMTEncoding_Term.Assume (_179_653))
in ((ttm), ((FStar_List.append decls ((d)::[])))))
end)))
end
| FStar_Syntax_Syntax.Tm_app (_86_830) -> begin
(

let _86_834 = (FStar_Syntax_Util.head_and_args t0)
in (match (_86_834) with
| (head, args_e) -> begin
(match ((let _179_655 = (let _179_654 = (FStar_Syntax_Subst.compress head)
in _179_654.FStar_Syntax_Syntax.n)
in ((_179_655), (args_e)))) with
| (_86_836, _86_838) when (head_redex env head) -> begin
(let _179_656 = (whnf env t)
in (encode_term _179_656 env))
end
| ((FStar_Syntax_Syntax.Tm_uinst ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar (fv); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, _), (_)::((v1, _))::((v2, _))::[])) | ((FStar_Syntax_Syntax.Tm_fvar (fv), (_)::((v1, _))::((v2, _))::[])) when (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.lexcons_lid) -> begin
(

let _86_878 = (encode_term v1 env)
in (match (_86_878) with
| (v1, decls1) -> begin
(

let _86_881 = (encode_term v2 env)
in (match (_86_881) with
| (v2, decls2) -> begin
(let _179_657 = (FStar_SMTEncoding_Term.mk_LexCons v1 v2)
in ((_179_657), ((FStar_List.append decls1 decls2))))
end))
end))
end
| (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_reify), (_86_890)::(_86_887)::_86_885) -> begin
(

let e0 = (let _179_661 = (let _179_660 = (let _179_659 = (let _179_658 = (FStar_List.hd args_e)
in (_179_658)::[])
in ((head), (_179_659)))
in FStar_Syntax_Syntax.Tm_app (_179_660))
in (FStar_Syntax_Syntax.mk _179_661 None head.FStar_Syntax_Syntax.pos))
in (

let e = (let _179_664 = (let _179_663 = (let _179_662 = (FStar_List.tl args_e)
in ((e0), (_179_662)))
in FStar_Syntax_Syntax.Tm_app (_179_663))
in (FStar_Syntax_Syntax.mk _179_664 None t0.FStar_Syntax_Syntax.pos))
in (encode_term e env)))
end
| (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_reify), ((arg, _86_899))::[]) -> begin
(

let _86_905 = (encode_term arg env)
in (match (_86_905) with
| (tm, decls) -> begin
(let _179_665 = (FStar_SMTEncoding_Term.mk (FStar_SMTEncoding_Term.App (((FStar_SMTEncoding_Term.Var ("Reify")), ((tm)::[])))))
in ((_179_665), (decls)))
end))
end
| (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_reflect (_86_907)), ((arg, _86_912))::[]) -> begin
(encode_term arg env)
end
| _86_917 -> begin
(

let _86_920 = (encode_args args_e env)
in (match (_86_920) with
| (args, decls) -> begin
(

let encode_partial_app = (fun ht_opt -> (

let _86_925 = (encode_term head env)
in (match (_86_925) with
| (head, decls') -> begin
(

let app_tm = (mk_Apply_args head args)
in (match (ht_opt) with
| None -> begin
((app_tm), ((FStar_List.append decls decls')))
end
| Some (formals, c) -> begin
(

let _86_934 = (FStar_Util.first_N (FStar_List.length args_e) formals)
in (match (_86_934) with
| (formals, rest) -> begin
(

let subst = (FStar_List.map2 (fun _86_938 _86_942 -> (match (((_86_938), (_86_942))) with
| ((bv, _86_937), (a, _86_941)) -> begin
FStar_Syntax_Syntax.NT (((bv), (a)))
end)) formals args_e)
in (

let ty = (let _179_670 = (FStar_Syntax_Util.arrow rest c)
in (FStar_All.pipe_right _179_670 (FStar_Syntax_Subst.subst subst)))
in (

let _86_947 = (encode_term_pred None ty env app_tm)
in (match (_86_947) with
| (has_type, decls'') -> begin
(

let cvars = (FStar_SMTEncoding_Term.free_variables has_type)
in (

let e_typing = (let _179_676 = (let _179_675 = (FStar_SMTEncoding_Term.mkForall ((((has_type)::[])::[]), (cvars), (has_type)))
in (let _179_674 = (let _179_673 = (let _179_672 = (let _179_671 = (FStar_Util.digest_of_string app_tm.FStar_SMTEncoding_Term.hash)
in (Prims.strcat "partial_app_typing_" _179_671))
in (varops.mk_unique _179_672))
in Some (_179_673))
in ((_179_675), (Some ("Partial app typing")), (_179_674))))
in FStar_SMTEncoding_Term.Assume (_179_676))
in ((app_tm), ((FStar_List.append decls (FStar_List.append decls' (FStar_List.append decls'' ((e_typing)::[]))))))))
end))))
end))
end))
end)))
in (

let encode_full_app = (fun fv -> (

let _86_954 = (lookup_free_var_sym env fv)
in (match (_86_954) with
| (fname, fuel_args) -> begin
(

let tm = (FStar_SMTEncoding_Term.mkApp' ((fname), ((FStar_List.append fuel_args args))))
in ((tm), (decls)))
end)))
in (

let head = (FStar_Syntax_Subst.compress head)
in (

let head_type = (match (head.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.Tm_uinst ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_name (x); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, _)) | (FStar_Syntax_Syntax.Tm_name (x)) -> begin
Some (x.FStar_Syntax_Syntax.sort)
end
| (FStar_Syntax_Syntax.Tm_uinst ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar (fv); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, _)) | (FStar_Syntax_Syntax.Tm_fvar (fv)) -> begin
(let _179_680 = (let _179_679 = (FStar_TypeChecker_Env.lookup_lid env.tcenv fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)
in (FStar_All.pipe_right _179_679 Prims.snd))
in Some (_179_680))
end
| FStar_Syntax_Syntax.Tm_ascribed (_86_986, FStar_Util.Inl (t), _86_990) -> begin
Some (t)
end
| FStar_Syntax_Syntax.Tm_ascribed (_86_994, FStar_Util.Inr (c), _86_998) -> begin
Some ((FStar_Syntax_Util.comp_result c))
end
| _86_1002 -> begin
None
end)
in (match (head_type) with
| None -> begin
(encode_partial_app None)
end
| Some (head_type) -> begin
(

let head_type = (let _179_681 = (FStar_TypeChecker_Normalize.normalize_refinement ((FStar_TypeChecker_Normalize.WHNF)::(FStar_TypeChecker_Normalize.EraseUniverses)::[]) env.tcenv head_type)
in (FStar_All.pipe_left FStar_Syntax_Util.unrefine _179_681))
in (

let _86_1010 = (curried_arrow_formals_comp head_type)
in (match (_86_1010) with
| (formals, c) -> begin
(match (head.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.Tm_uinst ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar (fv); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, _)) | (FStar_Syntax_Syntax.Tm_fvar (fv)) when ((FStar_List.length formals) = (FStar_List.length args)) -> begin
(encode_full_app fv.FStar_Syntax_Syntax.fv_name)
end
| _86_1026 -> begin
if ((FStar_List.length formals) > (FStar_List.length args)) then begin
(encode_partial_app (Some (((formals), (c)))))
end else begin
(encode_partial_app None)
end
end)
end)))
end)))))
end))
end)
end))
end
| FStar_Syntax_Syntax.Tm_abs (bs, body, lopt) -> begin
(

let _86_1035 = (FStar_Syntax_Subst.open_term' bs body)
in (match (_86_1035) with
| (bs, body, opening) -> begin
(

let fallback = (fun _86_1037 -> (match (()) with
| () -> begin
(

let f = (varops.fresh "Tm_abs")
in (

let decl = FStar_SMTEncoding_Term.DeclFun (((f), ([]), (FStar_SMTEncoding_Term.Term_sort), (Some ("Imprecise function encoding"))))
in (let _179_684 = (FStar_SMTEncoding_Term.mkFreeV ((f), (FStar_SMTEncoding_Term.Term_sort)))
in ((_179_684), ((decl)::[])))))
end))
in (

let is_impure = (fun _86_9 -> (match (_86_9) with
| FStar_Util.Inl (lc) -> begin
(not ((FStar_Syntax_Util.is_pure_or_ghost_lcomp lc)))
end
| FStar_Util.Inr (eff) -> begin
(let _179_687 = (FStar_TypeChecker_Util.is_pure_or_ghost_effect env.tcenv eff)
in (FStar_All.pipe_right _179_687 Prims.op_Negation))
end))
in (

let codomain_eff = (fun lc -> (match (lc) with
| FStar_Util.Inl (lc) -> begin
(let _179_692 = (let _179_690 = (lc.FStar_Syntax_Syntax.comp ())
in (FStar_Syntax_Subst.subst_comp opening _179_690))
in (FStar_All.pipe_right _179_692 (fun _179_691 -> Some (_179_691))))
end
| FStar_Util.Inr (eff) -> begin
(

let new_uvar = (fun _86_1053 -> (match (()) with
| () -> begin
(let _179_695 = (FStar_TypeChecker_Rel.new_uvar FStar_Range.dummyRange [] FStar_Syntax_Util.ktype0)
in (FStar_All.pipe_right _179_695 Prims.fst))
end))
in if (FStar_Ident.lid_equals eff FStar_Syntax_Const.effect_Tot_lid) then begin
(let _179_698 = (let _179_696 = (new_uvar ())
in (FStar_Syntax_Syntax.mk_Total _179_696))
in (FStar_All.pipe_right _179_698 (fun _179_697 -> Some (_179_697))))
end else begin
if (FStar_Ident.lid_equals eff FStar_Syntax_Const.effect_GTot_lid) then begin
(let _179_701 = (let _179_699 = (new_uvar ())
in (FStar_Syntax_Syntax.mk_GTotal _179_699))
in (FStar_All.pipe_right _179_701 (fun _179_700 -> Some (_179_700))))
end else begin
None
end
end)
end))
in (match (lopt) with
| None -> begin
(

let _86_1055 = (let _179_703 = (let _179_702 = (FStar_Syntax_Print.term_to_string t0)
in (FStar_Util.format1 "Losing precision when encoding a function literal: %s" _179_702))
in (FStar_TypeChecker_Errors.warn t0.FStar_Syntax_Syntax.pos _179_703))
in (fallback ()))
end
| Some (lc) -> begin
if (is_impure lc) then begin
(fallback ())
end else begin
(

let _86_1065 = (encode_binders None bs env)
in (match (_86_1065) with
| (vars, guards, envbody, decls, _86_1064) -> begin
(

let _86_1068 = (encode_term body envbody)
in (match (_86_1068) with
| (body, decls') -> begin
(

let key_body = (let _179_707 = (let _179_706 = (let _179_705 = (let _179_704 = (FStar_SMTEncoding_Term.mk_and_l guards)
in ((_179_704), (body)))
in (FStar_SMTEncoding_Term.mkImp _179_705))
in (([]), (vars), (_179_706)))
in (FStar_SMTEncoding_Term.mkForall _179_707))
in (

let cvars = (FStar_SMTEncoding_Term.free_variables key_body)
in (

let tkey = (FStar_SMTEncoding_Term.mkForall (([]), (cvars), (key_body)))
in (match ((FStar_Util.smap_try_find env.cache tkey.FStar_SMTEncoding_Term.hash)) with
| Some (t, _86_1074, _86_1076) -> begin
(let _179_710 = (let _179_709 = (let _179_708 = (FStar_List.map FStar_SMTEncoding_Term.mkFreeV cvars)
in ((t), (_179_708)))
in (FStar_SMTEncoding_Term.mkApp _179_709))
in ((_179_710), ([])))
end
| None -> begin
(match ((is_eta env vars body)) with
| Some (t) -> begin
((t), ([]))
end
| None -> begin
(

let cvar_sorts = (FStar_List.map Prims.snd cvars)
in (

let fsym = (let _179_712 = (let _179_711 = (FStar_Util.digest_of_string tkey.FStar_SMTEncoding_Term.hash)
in (Prims.strcat "Tm_abs_" _179_711))
in (varops.mk_unique _179_712))
in (

let fdecl = FStar_SMTEncoding_Term.DeclFun (((fsym), (cvar_sorts), (FStar_SMTEncoding_Term.Term_sort), (None)))
in (

let f = (let _179_714 = (let _179_713 = (FStar_List.map FStar_SMTEncoding_Term.mkFreeV cvars)
in ((fsym), (_179_713)))
in (FStar_SMTEncoding_Term.mkApp _179_714))
in (

let app = (mk_Apply f vars)
in (

let typing_f = (match ((codomain_eff lc)) with
| None -> begin
[]
end
| Some (c) -> begin
(

let tfun = (FStar_Syntax_Util.arrow bs c)
in (

let _86_1094 = (encode_term_pred None tfun env f)
in (match (_86_1094) with
| (f_has_t, decls'') -> begin
(

let a_name = Some ((Prims.strcat "typing_" fsym))
in (let _179_718 = (let _179_717 = (let _179_716 = (let _179_715 = (FStar_SMTEncoding_Term.mkForall ((((f)::[])::[]), (cvars), (f_has_t)))
in ((_179_715), (a_name), (a_name)))
in FStar_SMTEncoding_Term.Assume (_179_716))
in (_179_717)::[])
in (FStar_List.append decls'' _179_718)))
end)))
end)
in (

let interp_f = (

let a_name = Some ((Prims.strcat "interpretation_" fsym))
in (let _179_722 = (let _179_721 = (let _179_720 = (let _179_719 = (FStar_SMTEncoding_Term.mkEq ((app), (body)))
in ((((app)::[])::[]), ((FStar_List.append vars cvars)), (_179_719)))
in (FStar_SMTEncoding_Term.mkForall _179_720))
in ((_179_721), (a_name), (a_name)))
in FStar_SMTEncoding_Term.Assume (_179_722)))
in (

let f_decls = (FStar_List.append decls (FStar_List.append decls' (FStar_List.append ((fdecl)::typing_f) ((interp_f)::[]))))
in (

let _86_1100 = (FStar_Util.smap_add env.cache tkey.FStar_SMTEncoding_Term.hash ((fsym), (cvar_sorts), (f_decls)))
in ((f), (f_decls)))))))))))
end)
end))))
end))
end))
end
end))))
end))
end
| FStar_Syntax_Syntax.Tm_let ((_86_1103, ({FStar_Syntax_Syntax.lbname = FStar_Util.Inr (_86_1115); FStar_Syntax_Syntax.lbunivs = _86_1113; FStar_Syntax_Syntax.lbtyp = _86_1111; FStar_Syntax_Syntax.lbeff = _86_1109; FStar_Syntax_Syntax.lbdef = _86_1107})::_86_1105), _86_1121) -> begin
(FStar_All.failwith "Impossible: already handled by encoding of Sig_let")
end
| FStar_Syntax_Syntax.Tm_let ((false, ({FStar_Syntax_Syntax.lbname = FStar_Util.Inl (x); FStar_Syntax_Syntax.lbunivs = _86_1130; FStar_Syntax_Syntax.lbtyp = t1; FStar_Syntax_Syntax.lbeff = _86_1127; FStar_Syntax_Syntax.lbdef = e1})::[]), e2) -> begin
(encode_let x t1 e1 e2 env encode_term)
end
| FStar_Syntax_Syntax.Tm_let (_86_1140) -> begin
(

let _86_1142 = (FStar_TypeChecker_Errors.diag t0.FStar_Syntax_Syntax.pos "Non-top-level recursive functions are not yet fully encoded to the SMT solver; you may not be able to prove some facts")
in (

let e = (varops.fresh "let-rec")
in (

let decl_e = FStar_SMTEncoding_Term.DeclFun (((e), ([]), (FStar_SMTEncoding_Term.Term_sort), (None)))
in (let _179_723 = (FStar_SMTEncoding_Term.mkFreeV ((e), (FStar_SMTEncoding_Term.Term_sort)))
in ((_179_723), ((decl_e)::[]))))))
end
| FStar_Syntax_Syntax.Tm_match (e, pats) -> begin
(encode_match e pats FStar_SMTEncoding_Term.mk_Term_unit env encode_term)
end))))
and encode_let : FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term  ->  env_t  ->  (FStar_Syntax_Syntax.term  ->  env_t  ->  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))  ->  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t) = (fun x t1 e1 e2 env encode_body -> (

let _86_1158 = (encode_term e1 env)
in (match (_86_1158) with
| (ee1, decls1) -> begin
(

let _86_1161 = (FStar_Syntax_Subst.open_term ((((x), (None)))::[]) e2)
in (match (_86_1161) with
| (xs, e2) -> begin
(

let _86_1165 = (FStar_List.hd xs)
in (match (_86_1165) with
| (x, _86_1164) -> begin
(

let env' = (push_term_var env x ee1)
in (

let _86_1169 = (encode_body e2 env')
in (match (_86_1169) with
| (ee2, decls2) -> begin
((ee2), ((FStar_List.append decls1 decls2)))
end)))
end))
end))
end)))
and encode_match : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.branch Prims.list  ->  FStar_SMTEncoding_Term.term  ->  env_t  ->  (FStar_Syntax_Syntax.term  ->  env_t  ->  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))  ->  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t) = (fun e pats default_case env encode_br -> (

let _86_1177 = (encode_term e env)
in (match (_86_1177) with
| (scr, decls) -> begin
(

let _86_1214 = (FStar_List.fold_right (fun b _86_1181 -> (match (_86_1181) with
| (else_case, decls) -> begin
(

let _86_1185 = (FStar_Syntax_Subst.open_branch b)
in (match (_86_1185) with
| (p, w, br) -> begin
(

let patterns = (encode_pat env p)
in (FStar_List.fold_right (fun _86_1189 _86_1192 -> (match (((_86_1189), (_86_1192))) with
| ((env0, pattern), (else_case, decls)) -> begin
(

let guard = (pattern.guard scr)
in (

let projections = (pattern.projections scr)
in (

let env = (FStar_All.pipe_right projections (FStar_List.fold_left (fun env _86_1198 -> (match (_86_1198) with
| (x, t) -> begin
(push_term_var env x t)
end)) env))
in (

let _86_1208 = (match (w) with
| None -> begin
((guard), ([]))
end
| Some (w) -> begin
(

let _86_1205 = (encode_term w env)
in (match (_86_1205) with
| (w, decls2) -> begin
(let _179_757 = (let _179_756 = (let _179_755 = (let _179_754 = (let _179_753 = (FStar_SMTEncoding_Term.boxBool FStar_SMTEncoding_Term.mkTrue)
in ((w), (_179_753)))
in (FStar_SMTEncoding_Term.mkEq _179_754))
in ((guard), (_179_755)))
in (FStar_SMTEncoding_Term.mkAnd _179_756))
in ((_179_757), (decls2)))
end))
end)
in (match (_86_1208) with
| (guard, decls2) -> begin
(

let _86_1211 = (encode_br br env)
in (match (_86_1211) with
| (br, decls3) -> begin
(let _179_758 = (FStar_SMTEncoding_Term.mkITE ((guard), (br), (else_case)))
in ((_179_758), ((FStar_List.append decls (FStar_List.append decls2 decls3)))))
end))
end)))))
end)) patterns ((else_case), (decls))))
end))
end)) pats ((default_case), (decls)))
in (match (_86_1214) with
| (match_tm, decls) -> begin
((match_tm), (decls))
end))
end)))
and encode_pat : env_t  ->  FStar_Syntax_Syntax.pat  ->  (env_t * pattern) Prims.list = (fun env pat -> (match (pat.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj (ps) -> begin
(FStar_List.map (encode_one_pat env) ps)
end
| _86_1220 -> begin
(let _179_761 = (encode_one_pat env pat)
in (_179_761)::[])
end))
and encode_one_pat : env_t  ->  FStar_Syntax_Syntax.pat  ->  (env_t * pattern) = (fun env pat -> (

let _86_1223 = if (FStar_TypeChecker_Env.debug env.tcenv FStar_Options.Low) then begin
(let _179_764 = (FStar_Syntax_Print.pat_to_string pat)
in (FStar_Util.print1 "Encoding pattern %s\n" _179_764))
end else begin
()
end
in (

let _86_1227 = (FStar_TypeChecker_Util.decorated_pattern_as_term pat)
in (match (_86_1227) with
| (vars, pat_term) -> begin
(

let _86_1239 = (FStar_All.pipe_right vars (FStar_List.fold_left (fun _86_1230 v -> (match (_86_1230) with
| (env, vars) -> begin
(

let _86_1236 = (gen_term_var env v)
in (match (_86_1236) with
| (xx, _86_1234, env) -> begin
((env), ((((v), (((xx), (FStar_SMTEncoding_Term.Term_sort)))))::vars))
end))
end)) ((env), ([]))))
in (match (_86_1239) with
| (env, vars) -> begin
(

let rec mk_guard = (fun pat scrutinee -> (match (pat.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj (_86_1244) -> begin
(FStar_All.failwith "Impossible")
end
| (FStar_Syntax_Syntax.Pat_var (_)) | (FStar_Syntax_Syntax.Pat_wild (_)) | (FStar_Syntax_Syntax.Pat_dot_term (_)) -> begin
FStar_SMTEncoding_Term.mkTrue
end
| FStar_Syntax_Syntax.Pat_constant (c) -> begin
(let _179_772 = (let _179_771 = (encode_const c)
in ((scrutinee), (_179_771)))
in (FStar_SMTEncoding_Term.mkEq _179_772))
end
| FStar_Syntax_Syntax.Pat_cons (f, args) -> begin
(

let is_f = (mk_data_tester env f.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v scrutinee)
in (

let sub_term_guards = (FStar_All.pipe_right args (FStar_List.mapi (fun i _86_1266 -> (match (_86_1266) with
| (arg, _86_1265) -> begin
(

let proj = (primitive_projector_by_pos env.tcenv f.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v i)
in (let _179_775 = (FStar_SMTEncoding_Term.mkApp ((proj), ((scrutinee)::[])))
in (mk_guard arg _179_775)))
end))))
in (FStar_SMTEncoding_Term.mk_and_l ((is_f)::sub_term_guards))))
end))
in (

let rec mk_projections = (fun pat scrutinee -> (match (pat.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj (_86_1273) -> begin
(FStar_All.failwith "Impossible")
end
| (FStar_Syntax_Syntax.Pat_dot_term (x, _)) | (FStar_Syntax_Syntax.Pat_var (x)) | (FStar_Syntax_Syntax.Pat_wild (x)) -> begin
(((x), (scrutinee)))::[]
end
| FStar_Syntax_Syntax.Pat_constant (_86_1283) -> begin
[]
end
| FStar_Syntax_Syntax.Pat_cons (f, args) -> begin
(let _179_783 = (FStar_All.pipe_right args (FStar_List.mapi (fun i _86_1293 -> (match (_86_1293) with
| (arg, _86_1292) -> begin
(

let proj = (primitive_projector_by_pos env.tcenv f.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v i)
in (let _179_782 = (FStar_SMTEncoding_Term.mkApp ((proj), ((scrutinee)::[])))
in (mk_projections arg _179_782)))
end))))
in (FStar_All.pipe_right _179_783 FStar_List.flatten))
end))
in (

let pat_term = (fun _86_1296 -> (match (()) with
| () -> begin
(encode_term pat_term env)
end))
in (

let pattern = {pat_vars = vars; pat_term = pat_term; guard = (mk_guard pat); projections = (mk_projections pat)}
in ((env), (pattern))))))
end))
end))))
and encode_args : FStar_Syntax_Syntax.args  ->  env_t  ->  (FStar_SMTEncoding_Term.term Prims.list * FStar_SMTEncoding_Term.decls_t) = (fun l env -> (

let _86_1312 = (FStar_All.pipe_right l (FStar_List.fold_left (fun _86_1302 _86_1306 -> (match (((_86_1302), (_86_1306))) with
| ((tms, decls), (t, _86_1305)) -> begin
(

let _86_1309 = (encode_term t env)
in (match (_86_1309) with
| (t, decls') -> begin
(((t)::tms), ((FStar_List.append decls decls')))
end))
end)) (([]), ([]))))
in (match (_86_1312) with
| (l, decls) -> begin
(((FStar_List.rev l)), (decls))
end)))
and encode_function_type_as_formula : FStar_SMTEncoding_Term.term Prims.option  ->  FStar_Syntax_Syntax.term Prims.option  ->  FStar_Syntax_Syntax.typ  ->  env_t  ->  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t) = (fun induction_on new_pats t env -> (

let list_elements = (fun e -> (match ((FStar_Syntax_Util.list_elements e)) with
| Some (l) -> begin
l
end
| None -> begin
(

let _86_1322 = (FStar_TypeChecker_Errors.warn e.FStar_Syntax_Syntax.pos "SMT pattern is not a list literal; ignoring the pattern")
in [])
end))
in (

let one_pat = (fun p -> (

let _86_1328 = (let _179_798 = (FStar_Syntax_Util.unmeta p)
in (FStar_All.pipe_right _179_798 FStar_Syntax_Util.head_and_args))
in (match (_86_1328) with
| (head, args) -> begin
(match ((let _179_800 = (let _179_799 = (FStar_Syntax_Util.un_uinst head)
in _179_799.FStar_Syntax_Syntax.n)
in ((_179_800), (args)))) with
| (FStar_Syntax_Syntax.Tm_fvar (fv), ((_86_1336, _86_1338))::((e, _86_1333))::[]) when (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.smtpat_lid) -> begin
((e), (None))
end
| (FStar_Syntax_Syntax.Tm_fvar (fv), ((e, _86_1346))::[]) when (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.smtpatT_lid) -> begin
((e), (None))
end
| _86_1351 -> begin
(FStar_All.failwith "Unexpected pattern term")
end)
end)))
in (

let lemma_pats = (fun p -> (

let elts = (list_elements p)
in (

let smt_pat_or = (fun t -> (

let _86_1359 = (let _179_805 = (FStar_Syntax_Util.unmeta t)
in (FStar_All.pipe_right _179_805 FStar_Syntax_Util.head_and_args))
in (match (_86_1359) with
| (head, args) -> begin
(match ((let _179_807 = (let _179_806 = (FStar_Syntax_Util.un_uinst head)
in _179_806.FStar_Syntax_Syntax.n)
in ((_179_807), (args)))) with
| (FStar_Syntax_Syntax.Tm_fvar (fv), ((e, _86_1364))::[]) when (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.smtpatOr_lid) -> begin
Some (e)
end
| _86_1369 -> begin
None
end)
end)))
in (match (elts) with
| (t)::[] -> begin
(match ((smt_pat_or t)) with
| Some (e) -> begin
(let _179_810 = (list_elements e)
in (FStar_All.pipe_right _179_810 (FStar_List.map (fun branch -> (let _179_809 = (list_elements branch)
in (FStar_All.pipe_right _179_809 (FStar_List.map one_pat)))))))
end
| _86_1376 -> begin
(let _179_811 = (FStar_All.pipe_right elts (FStar_List.map one_pat))
in (_179_811)::[])
end)
end
| _86_1378 -> begin
(let _179_812 = (FStar_All.pipe_right elts (FStar_List.map one_pat))
in (_179_812)::[])
end))))
in (

let _86_1412 = (match ((let _179_813 = (FStar_Syntax_Subst.compress t)
in _179_813.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (binders, c) -> begin
(

let _86_1385 = (FStar_Syntax_Subst.open_comp binders c)
in (match (_86_1385) with
| (binders, c) -> begin
(

let ct = (FStar_Syntax_Util.comp_to_comp_typ c)
in (match (ct.FStar_Syntax_Syntax.effect_args) with
| ((pre, _86_1397))::((post, _86_1393))::((pats, _86_1389))::[] -> begin
(

let pats' = (match (new_pats) with
| Some (new_pats') -> begin
new_pats'
end
| None -> begin
pats
end)
in (let _179_814 = (lemma_pats pats')
in ((binders), (pre), (post), (_179_814))))
end
| _86_1405 -> begin
(FStar_All.failwith "impos")
end))
end))
end
| _86_1407 -> begin
(FStar_All.failwith "Impos")
end)
in (match (_86_1412) with
| (binders, pre, post, patterns) -> begin
(

let _86_1419 = (encode_binders None binders env)
in (match (_86_1419) with
| (vars, guards, env, decls, _86_1418) -> begin
(

let _86_1432 = (let _179_818 = (FStar_All.pipe_right patterns (FStar_List.map (fun branch -> (

let _86_1429 = (let _179_817 = (FStar_All.pipe_right branch (FStar_List.map (fun _86_1424 -> (match (_86_1424) with
| (t, _86_1423) -> begin
(encode_term t (

let _86_1425 = env
in {bindings = _86_1425.bindings; depth = _86_1425.depth; tcenv = _86_1425.tcenv; warn = _86_1425.warn; cache = _86_1425.cache; nolabels = _86_1425.nolabels; use_zfuel_name = true; encode_non_total_function_typ = _86_1425.encode_non_total_function_typ}))
end))))
in (FStar_All.pipe_right _179_817 FStar_List.unzip))
in (match (_86_1429) with
| (pats, decls) -> begin
((pats), (decls))
end)))))
in (FStar_All.pipe_right _179_818 FStar_List.unzip))
in (match (_86_1432) with
| (pats, decls') -> begin
(

let decls' = (FStar_List.flatten decls')
in (

let pats = (match (induction_on) with
| None -> begin
pats
end
| Some (e) -> begin
(match (vars) with
| [] -> begin
pats
end
| (l)::[] -> begin
(FStar_All.pipe_right pats (FStar_List.map (fun p -> (let _179_821 = (let _179_820 = (FStar_SMTEncoding_Term.mkFreeV l)
in (FStar_SMTEncoding_Term.mk_Precedes _179_820 e))
in (_179_821)::p))))
end
| _86_1442 -> begin
(

let rec aux = (fun tl vars -> (match (vars) with
| [] -> begin
(FStar_All.pipe_right pats (FStar_List.map (fun p -> (let _179_827 = (FStar_SMTEncoding_Term.mk_Precedes tl e)
in (_179_827)::p))))
end
| ((x, FStar_SMTEncoding_Term.Term_sort))::vars -> begin
(let _179_829 = (let _179_828 = (FStar_SMTEncoding_Term.mkFreeV ((x), (FStar_SMTEncoding_Term.Term_sort)))
in (FStar_SMTEncoding_Term.mk_LexCons _179_828 tl))
in (aux _179_829 vars))
end
| _86_1454 -> begin
pats
end))
in (let _179_830 = (FStar_SMTEncoding_Term.mkFreeV (("Prims.LexTop"), (FStar_SMTEncoding_Term.Term_sort)))
in (aux _179_830 vars)))
end)
end)
in (

let env = (

let _86_1456 = env
in {bindings = _86_1456.bindings; depth = _86_1456.depth; tcenv = _86_1456.tcenv; warn = _86_1456.warn; cache = _86_1456.cache; nolabels = true; use_zfuel_name = _86_1456.use_zfuel_name; encode_non_total_function_typ = _86_1456.encode_non_total_function_typ})
in (

let _86_1461 = (let _179_831 = (FStar_Syntax_Util.unmeta pre)
in (encode_formula _179_831 env))
in (match (_86_1461) with
| (pre, decls'') -> begin
(

let _86_1464 = (let _179_832 = (FStar_Syntax_Util.unmeta post)
in (encode_formula _179_832 env))
in (match (_86_1464) with
| (post, decls''') -> begin
(

let decls = (FStar_List.append decls (FStar_List.append (FStar_List.flatten decls') (FStar_List.append decls'' decls''')))
in (let _179_837 = (let _179_836 = (let _179_835 = (let _179_834 = (let _179_833 = (FStar_SMTEncoding_Term.mk_and_l ((pre)::guards))
in ((_179_833), (post)))
in (FStar_SMTEncoding_Term.mkImp _179_834))
in ((pats), (vars), (_179_835)))
in (FStar_SMTEncoding_Term.mkForall _179_836))
in ((_179_837), (decls))))
end))
end)))))
end))
end))
end))))))
and encode_formula : FStar_Syntax_Syntax.typ  ->  env_t  ->  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t) = (fun phi env -> (

let debug = (fun phi -> if (FStar_All.pipe_left (FStar_TypeChecker_Env.debug env.tcenv) (FStar_Options.Other ("SMTEncoding"))) then begin
(let _179_843 = (FStar_Syntax_Print.tag_of_term phi)
in (let _179_842 = (FStar_Syntax_Print.term_to_string phi)
in (FStar_Util.print2 "Formula (%s)  %s\n" _179_843 _179_842)))
end else begin
()
end)
in (

let enc = (fun f l -> (

let _86_1480 = (FStar_Util.fold_map (fun decls x -> (

let _86_1477 = (encode_term (Prims.fst x) env)
in (match (_86_1477) with
| (t, decls') -> begin
(((FStar_List.append decls decls')), (t))
end))) [] l)
in (match (_86_1480) with
| (decls, args) -> begin
(let _179_859 = (f args)
in ((_179_859), (decls)))
end)))
in (

let const_op = (fun f _86_1483 -> ((f), ([])))
in (

let un_op = (fun f l -> (let _179_873 = (FStar_List.hd l)
in (FStar_All.pipe_left f _179_873)))
in (

let bin_op = (fun f _86_10 -> (match (_86_10) with
| (t1)::(t2)::[] -> begin
(f ((t1), (t2)))
end
| _86_1494 -> begin
(FStar_All.failwith "Impossible")
end))
in (

let enc_prop_c = (fun f l -> (

let _86_1509 = (FStar_Util.fold_map (fun decls _86_1503 -> (match (_86_1503) with
| (t, _86_1502) -> begin
(

let _86_1506 = (encode_formula t env)
in (match (_86_1506) with
| (phi, decls') -> begin
(((FStar_List.append decls decls')), (phi))
end))
end)) [] l)
in (match (_86_1509) with
| (decls, phis) -> begin
(let _179_898 = (f phis)
in ((_179_898), (decls)))
end)))
in (

let eq_op = (fun _86_11 -> (match (_86_11) with
| ((_)::(e1)::(e2)::[]) | ((_)::(_)::(e1)::(e2)::[]) -> begin
(enc (bin_op FStar_SMTEncoding_Term.mkEq) ((e1)::(e2)::[]))
end
| l -> begin
(enc (bin_op FStar_SMTEncoding_Term.mkEq) l)
end))
in (

let mk_imp = (fun _86_12 -> (match (_86_12) with
| ((lhs, _86_1530))::((rhs, _86_1526))::[] -> begin
(

let _86_1535 = (encode_formula rhs env)
in (match (_86_1535) with
| (l1, decls1) -> begin
(match (l1.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.True, _86_1538) -> begin
((l1), (decls1))
end
| _86_1542 -> begin
(

let _86_1545 = (encode_formula lhs env)
in (match (_86_1545) with
| (l2, decls2) -> begin
(let _179_903 = (FStar_SMTEncoding_Term.mkImp ((l2), (l1)))
in ((_179_903), ((FStar_List.append decls1 decls2))))
end))
end)
end))
end
| _86_1547 -> begin
(FStar_All.failwith "impossible")
end))
in (

let mk_ite = (fun _86_13 -> (match (_86_13) with
| ((guard, _86_1560))::((_then, _86_1556))::((_else, _86_1552))::[] -> begin
(

let _86_1565 = (encode_formula guard env)
in (match (_86_1565) with
| (g, decls1) -> begin
(

let _86_1568 = (encode_formula _then env)
in (match (_86_1568) with
| (t, decls2) -> begin
(

let _86_1571 = (encode_formula _else env)
in (match (_86_1571) with
| (e, decls3) -> begin
(

let res = (FStar_SMTEncoding_Term.mkITE ((g), (t), (e)))
in ((res), ((FStar_List.append decls1 (FStar_List.append decls2 decls3)))))
end))
end))
end))
end
| _86_1574 -> begin
(FStar_All.failwith "impossible")
end))
in (

let unboxInt_l = (fun f l -> (let _179_915 = (FStar_List.map FStar_SMTEncoding_Term.unboxInt l)
in (f _179_915)))
in (

let connectives = (let _179_971 = (let _179_924 = (FStar_All.pipe_left enc_prop_c (bin_op FStar_SMTEncoding_Term.mkAnd))
in ((FStar_Syntax_Const.and_lid), (_179_924)))
in (let _179_970 = (let _179_969 = (let _179_930 = (FStar_All.pipe_left enc_prop_c (bin_op FStar_SMTEncoding_Term.mkOr))
in ((FStar_Syntax_Const.or_lid), (_179_930)))
in (let _179_968 = (let _179_967 = (let _179_966 = (let _179_939 = (FStar_All.pipe_left enc_prop_c (bin_op FStar_SMTEncoding_Term.mkIff))
in ((FStar_Syntax_Const.iff_lid), (_179_939)))
in (let _179_965 = (let _179_964 = (let _179_963 = (let _179_948 = (FStar_All.pipe_left enc_prop_c (un_op FStar_SMTEncoding_Term.mkNot))
in ((FStar_Syntax_Const.not_lid), (_179_948)))
in (_179_963)::(((FStar_Syntax_Const.eq2_lid), (eq_op)))::(((FStar_Syntax_Const.eq3_lid), (eq_op)))::(((FStar_Syntax_Const.true_lid), ((const_op FStar_SMTEncoding_Term.mkTrue))))::(((FStar_Syntax_Const.false_lid), ((const_op FStar_SMTEncoding_Term.mkFalse))))::[])
in (((FStar_Syntax_Const.ite_lid), (mk_ite)))::_179_964)
in (_179_966)::_179_965))
in (((FStar_Syntax_Const.imp_lid), (mk_imp)))::_179_967)
in (_179_969)::_179_968))
in (_179_971)::_179_970))
in (

let rec fallback = (fun phi -> (match (phi.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_meta (phi', FStar_Syntax_Syntax.Meta_labeled (msg, r, b)) -> begin
(

let _86_1592 = (encode_formula phi' env)
in (match (_86_1592) with
| (phi, decls) -> begin
(let _179_974 = (FStar_SMTEncoding_Term.mk (FStar_SMTEncoding_Term.Labeled (((phi), (msg), (r)))))
in ((_179_974), (decls)))
end))
end
| FStar_Syntax_Syntax.Tm_meta (_86_1594) -> begin
(let _179_975 = (FStar_Syntax_Util.unmeta phi)
in (encode_formula _179_975 env))
end
| FStar_Syntax_Syntax.Tm_match (e, pats) -> begin
(

let _86_1602 = (encode_match e pats FStar_SMTEncoding_Term.mkFalse env encode_formula)
in (match (_86_1602) with
| (t, decls) -> begin
((t), (decls))
end))
end
| FStar_Syntax_Syntax.Tm_let ((false, ({FStar_Syntax_Syntax.lbname = FStar_Util.Inl (x); FStar_Syntax_Syntax.lbunivs = _86_1609; FStar_Syntax_Syntax.lbtyp = t1; FStar_Syntax_Syntax.lbeff = _86_1606; FStar_Syntax_Syntax.lbdef = e1})::[]), e2) -> begin
(

let _86_1620 = (encode_let x t1 e1 e2 env encode_formula)
in (match (_86_1620) with
| (t, decls) -> begin
((t), (decls))
end))
end
| FStar_Syntax_Syntax.Tm_app (head, args) -> begin
(

let head = (FStar_Syntax_Util.un_uinst head)
in (match (((head.FStar_Syntax_Syntax.n), (args))) with
| (FStar_Syntax_Syntax.Tm_fvar (fv), (_86_1637)::((x, _86_1634))::((t, _86_1630))::[]) when (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.has_type_lid) -> begin
(

let _86_1642 = (encode_term x env)
in (match (_86_1642) with
| (x, decls) -> begin
(

let _86_1645 = (encode_term t env)
in (match (_86_1645) with
| (t, decls') -> begin
(let _179_976 = (FStar_SMTEncoding_Term.mk_HasType x t)
in ((_179_976), ((FStar_List.append decls decls'))))
end))
end))
end
| (FStar_Syntax_Syntax.Tm_fvar (fv), ((r, _86_1658))::((msg, _86_1654))::((phi, _86_1650))::[]) when (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.labeled_lid) -> begin
(match ((let _179_980 = (let _179_977 = (FStar_Syntax_Subst.compress r)
in _179_977.FStar_Syntax_Syntax.n)
in (let _179_979 = (let _179_978 = (FStar_Syntax_Subst.compress msg)
in _179_978.FStar_Syntax_Syntax.n)
in ((_179_980), (_179_979))))) with
| (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_range (r)), FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_string (s, _86_1667))) -> begin
(

let phi = (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_meta (((phi), (FStar_Syntax_Syntax.Meta_labeled ((((FStar_Util.string_of_unicode s)), (r), (false))))))) None r)
in (fallback phi))
end
| _86_1674 -> begin
(fallback phi)
end)
end
| _86_1676 when (head_redex env head) -> begin
(let _179_981 = (whnf env phi)
in (encode_formula _179_981 env))
end
| _86_1678 -> begin
(

let _86_1681 = (encode_term phi env)
in (match (_86_1681) with
| (tt, decls) -> begin
(let _179_982 = (FStar_SMTEncoding_Term.mk_Valid tt)
in ((_179_982), (decls)))
end))
end))
end
| _86_1683 -> begin
(

let _86_1686 = (encode_term phi env)
in (match (_86_1686) with
| (tt, decls) -> begin
(let _179_983 = (FStar_SMTEncoding_Term.mk_Valid tt)
in ((_179_983), (decls)))
end))
end))
in (

let encode_q_body = (fun env bs ps body -> (

let _86_1698 = (encode_binders None bs env)
in (match (_86_1698) with
| (vars, guards, env, decls, _86_1697) -> begin
(

let _86_1711 = (let _179_995 = (FStar_All.pipe_right ps (FStar_List.map (fun p -> (

let _86_1708 = (let _179_994 = (FStar_All.pipe_right p (FStar_List.map (fun _86_1703 -> (match (_86_1703) with
| (t, _86_1702) -> begin
(encode_term t (

let _86_1704 = env
in {bindings = _86_1704.bindings; depth = _86_1704.depth; tcenv = _86_1704.tcenv; warn = _86_1704.warn; cache = _86_1704.cache; nolabels = _86_1704.nolabels; use_zfuel_name = true; encode_non_total_function_typ = _86_1704.encode_non_total_function_typ}))
end))))
in (FStar_All.pipe_right _179_994 FStar_List.unzip))
in (match (_86_1708) with
| (p, decls) -> begin
((p), ((FStar_List.flatten decls)))
end)))))
in (FStar_All.pipe_right _179_995 FStar_List.unzip))
in (match (_86_1711) with
| (pats, decls') -> begin
(

let _86_1714 = (encode_formula body env)
in (match (_86_1714) with
| (body, decls'') -> begin
(

let guards = (match (pats) with
| (({FStar_SMTEncoding_Term.tm = FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Var (gf), (p)::[]); FStar_SMTEncoding_Term.hash = _86_1718; FStar_SMTEncoding_Term.freevars = _86_1716})::[])::[] when ((FStar_Ident.text_of_lid FStar_Syntax_Const.guard_free) = gf) -> begin
[]
end
| _86_1729 -> begin
guards
end)
in (let _179_996 = (FStar_SMTEncoding_Term.mk_and_l guards)
in ((vars), (pats), (_179_996), (body), ((FStar_List.append decls (FStar_List.append (FStar_List.flatten decls') decls''))))))
end))
end))
end)))
in (

let _86_1731 = (debug phi)
in (

let phi = (FStar_Syntax_Util.unascribe phi)
in (

let check_pattern_vars = (fun vars pats -> (

let pats = (FStar_All.pipe_right pats (FStar_List.map (fun _86_1740 -> (match (_86_1740) with
| (x, _86_1739) -> begin
(FStar_TypeChecker_Normalize.normalize ((FStar_TypeChecker_Normalize.Beta)::FStar_TypeChecker_Normalize.AllowUnboundUniverses::FStar_TypeChecker_Normalize.EraseUniverses::[]) env.tcenv x)
end))))
in (match (pats) with
| [] -> begin
()
end
| (hd)::tl -> begin
(

let pat_vars = (let _179_1005 = (FStar_Syntax_Free.names hd)
in (FStar_List.fold_left (fun out x -> (let _179_1004 = (FStar_Syntax_Free.names x)
in (FStar_Util.set_union out _179_1004))) _179_1005 tl))
in (match ((FStar_All.pipe_right vars (FStar_Util.find_opt (fun _86_1752 -> (match (_86_1752) with
| (b, _86_1751) -> begin
(not ((FStar_Util.set_mem b pat_vars)))
end))))) with
| None -> begin
()
end
| Some (x, _86_1756) -> begin
(

let pos = (FStar_List.fold_left (fun out t -> (FStar_Range.union_ranges out t.FStar_Syntax_Syntax.pos)) hd.FStar_Syntax_Syntax.pos tl)
in (let _179_1010 = (let _179_1009 = (FStar_Syntax_Print.bv_to_string x)
in (FStar_Util.format1 "Pattern misses at least one bound variable: %s" _179_1009))
in (FStar_TypeChecker_Errors.warn pos _179_1010)))
end))
end)))
in (match ((FStar_Syntax_Util.destruct_typ_as_formula phi)) with
| None -> begin
(fallback phi)
end
| Some (FStar_Syntax_Util.BaseConn (op, arms)) -> begin
(match ((FStar_All.pipe_right connectives (FStar_List.tryFind (fun _86_1771 -> (match (_86_1771) with
| (l, _86_1770) -> begin
(FStar_Ident.lid_equals op l)
end))))) with
| None -> begin
(fallback phi)
end
| Some (_86_1774, f) -> begin
(f arms)
end)
end
| Some (FStar_Syntax_Util.QAll (vars, pats, body)) -> begin
(

let _86_1784 = (FStar_All.pipe_right pats (FStar_List.iter (check_pattern_vars vars)))
in (

let _86_1791 = (encode_q_body env vars pats body)
in (match (_86_1791) with
| (vars, pats, guard, body, decls) -> begin
(

let tm = (let _179_1028 = (let _179_1027 = (FStar_SMTEncoding_Term.mkImp ((guard), (body)))
in ((pats), (vars), (_179_1027)))
in (FStar_SMTEncoding_Term.mkForall _179_1028))
in ((tm), (decls)))
end)))
end
| Some (FStar_Syntax_Util.QEx (vars, pats, body)) -> begin
(

let _86_1799 = (FStar_All.pipe_right pats (FStar_List.iter (check_pattern_vars vars)))
in (

let _86_1806 = (encode_q_body env vars pats body)
in (match (_86_1806) with
| (vars, pats, guard, body, decls) -> begin
(let _179_1031 = (let _179_1030 = (let _179_1029 = (FStar_SMTEncoding_Term.mkAnd ((guard), (body)))
in ((pats), (vars), (_179_1029)))
in (FStar_SMTEncoding_Term.mkExists _179_1030))
in ((_179_1031), (decls)))
end)))
end))))))))))))))))))


type prims_t =
{mk : FStar_Ident.lident  ->  Prims.string  ->  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decl Prims.list); is : FStar_Ident.lident  ->  Prims.bool}


let is_Mkprims_t : prims_t  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkprims_t"))))


let prims : prims_t = (

let _86_1812 = (fresh_fvar "a" FStar_SMTEncoding_Term.Term_sort)
in (match (_86_1812) with
| (asym, a) -> begin
(

let _86_1815 = (fresh_fvar "x" FStar_SMTEncoding_Term.Term_sort)
in (match (_86_1815) with
| (xsym, x) -> begin
(

let _86_1818 = (fresh_fvar "y" FStar_SMTEncoding_Term.Term_sort)
in (match (_86_1818) with
| (ysym, y) -> begin
(

let deffun = (fun vars body x -> (FStar_SMTEncoding_Term.DefineFun (((x), (vars), (FStar_SMTEncoding_Term.Term_sort), (body), (None))))::[])
in (

let quant = (fun vars body x -> (

let xname_decl = (let _179_1074 = (let _179_1073 = (FStar_All.pipe_right vars (FStar_List.map Prims.snd))
in ((x), (_179_1073), (FStar_SMTEncoding_Term.Term_sort), (None)))
in FStar_SMTEncoding_Term.DeclFun (_179_1074))
in (

let xtok = (Prims.strcat x "@tok")
in (

let xtok_decl = FStar_SMTEncoding_Term.DeclFun (((xtok), ([]), (FStar_SMTEncoding_Term.Term_sort), (None)))
in (

let xapp = (let _179_1076 = (let _179_1075 = (FStar_List.map FStar_SMTEncoding_Term.mkFreeV vars)
in ((x), (_179_1075)))
in (FStar_SMTEncoding_Term.mkApp _179_1076))
in (

let xtok = (FStar_SMTEncoding_Term.mkApp ((xtok), ([])))
in (

let xtok_app = (mk_Apply xtok vars)
in (let _179_1090 = (let _179_1089 = (let _179_1088 = (let _179_1087 = (let _179_1080 = (let _179_1079 = (let _179_1078 = (let _179_1077 = (FStar_SMTEncoding_Term.mkEq ((xapp), (body)))
in ((((xapp)::[])::[]), (vars), (_179_1077)))
in (FStar_SMTEncoding_Term.mkForall _179_1078))
in ((_179_1079), (None), (Some ((Prims.strcat "primitive_" x)))))
in FStar_SMTEncoding_Term.Assume (_179_1080))
in (let _179_1086 = (let _179_1085 = (let _179_1084 = (let _179_1083 = (let _179_1082 = (let _179_1081 = (FStar_SMTEncoding_Term.mkEq ((xtok_app), (xapp)))
in ((((xtok_app)::[])::[]), (vars), (_179_1081)))
in (FStar_SMTEncoding_Term.mkForall _179_1082))
in ((_179_1083), (Some ("Name-token correspondence")), (Some ((Prims.strcat "token_correspondence_" x)))))
in FStar_SMTEncoding_Term.Assume (_179_1084))
in (_179_1085)::[])
in (_179_1087)::_179_1086))
in (xtok_decl)::_179_1088)
in (xname_decl)::_179_1089)
in ((xtok), (_179_1090))))))))))
in (

let axy = (((asym), (FStar_SMTEncoding_Term.Term_sort)))::(((xsym), (FStar_SMTEncoding_Term.Term_sort)))::(((ysym), (FStar_SMTEncoding_Term.Term_sort)))::[]
in (

let xy = (((xsym), (FStar_SMTEncoding_Term.Term_sort)))::(((ysym), (FStar_SMTEncoding_Term.Term_sort)))::[]
in (

let qx = (((xsym), (FStar_SMTEncoding_Term.Term_sort)))::[]
in (

let prims = (let _179_1250 = (let _179_1099 = (let _179_1098 = (let _179_1097 = (FStar_SMTEncoding_Term.mkEq ((x), (y)))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxBool _179_1097))
in (quant axy _179_1098))
in ((FStar_Syntax_Const.op_Eq), (_179_1099)))
in (let _179_1249 = (let _179_1248 = (let _179_1106 = (let _179_1105 = (let _179_1104 = (let _179_1103 = (FStar_SMTEncoding_Term.mkEq ((x), (y)))
in (FStar_SMTEncoding_Term.mkNot _179_1103))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxBool _179_1104))
in (quant axy _179_1105))
in ((FStar_Syntax_Const.op_notEq), (_179_1106)))
in (let _179_1247 = (let _179_1246 = (let _179_1115 = (let _179_1114 = (let _179_1113 = (let _179_1112 = (let _179_1111 = (FStar_SMTEncoding_Term.unboxInt x)
in (let _179_1110 = (FStar_SMTEncoding_Term.unboxInt y)
in ((_179_1111), (_179_1110))))
in (FStar_SMTEncoding_Term.mkLT _179_1112))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxBool _179_1113))
in (quant xy _179_1114))
in ((FStar_Syntax_Const.op_LT), (_179_1115)))
in (let _179_1245 = (let _179_1244 = (let _179_1124 = (let _179_1123 = (let _179_1122 = (let _179_1121 = (let _179_1120 = (FStar_SMTEncoding_Term.unboxInt x)
in (let _179_1119 = (FStar_SMTEncoding_Term.unboxInt y)
in ((_179_1120), (_179_1119))))
in (FStar_SMTEncoding_Term.mkLTE _179_1121))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxBool _179_1122))
in (quant xy _179_1123))
in ((FStar_Syntax_Const.op_LTE), (_179_1124)))
in (let _179_1243 = (let _179_1242 = (let _179_1133 = (let _179_1132 = (let _179_1131 = (let _179_1130 = (let _179_1129 = (FStar_SMTEncoding_Term.unboxInt x)
in (let _179_1128 = (FStar_SMTEncoding_Term.unboxInt y)
in ((_179_1129), (_179_1128))))
in (FStar_SMTEncoding_Term.mkGT _179_1130))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxBool _179_1131))
in (quant xy _179_1132))
in ((FStar_Syntax_Const.op_GT), (_179_1133)))
in (let _179_1241 = (let _179_1240 = (let _179_1142 = (let _179_1141 = (let _179_1140 = (let _179_1139 = (let _179_1138 = (FStar_SMTEncoding_Term.unboxInt x)
in (let _179_1137 = (FStar_SMTEncoding_Term.unboxInt y)
in ((_179_1138), (_179_1137))))
in (FStar_SMTEncoding_Term.mkGTE _179_1139))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxBool _179_1140))
in (quant xy _179_1141))
in ((FStar_Syntax_Const.op_GTE), (_179_1142)))
in (let _179_1239 = (let _179_1238 = (let _179_1151 = (let _179_1150 = (let _179_1149 = (let _179_1148 = (let _179_1147 = (FStar_SMTEncoding_Term.unboxInt x)
in (let _179_1146 = (FStar_SMTEncoding_Term.unboxInt y)
in ((_179_1147), (_179_1146))))
in (FStar_SMTEncoding_Term.mkSub _179_1148))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxInt _179_1149))
in (quant xy _179_1150))
in ((FStar_Syntax_Const.op_Subtraction), (_179_1151)))
in (let _179_1237 = (let _179_1236 = (let _179_1158 = (let _179_1157 = (let _179_1156 = (let _179_1155 = (FStar_SMTEncoding_Term.unboxInt x)
in (FStar_SMTEncoding_Term.mkMinus _179_1155))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxInt _179_1156))
in (quant qx _179_1157))
in ((FStar_Syntax_Const.op_Minus), (_179_1158)))
in (let _179_1235 = (let _179_1234 = (let _179_1167 = (let _179_1166 = (let _179_1165 = (let _179_1164 = (let _179_1163 = (FStar_SMTEncoding_Term.unboxInt x)
in (let _179_1162 = (FStar_SMTEncoding_Term.unboxInt y)
in ((_179_1163), (_179_1162))))
in (FStar_SMTEncoding_Term.mkAdd _179_1164))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxInt _179_1165))
in (quant xy _179_1166))
in ((FStar_Syntax_Const.op_Addition), (_179_1167)))
in (let _179_1233 = (let _179_1232 = (let _179_1176 = (let _179_1175 = (let _179_1174 = (let _179_1173 = (let _179_1172 = (FStar_SMTEncoding_Term.unboxInt x)
in (let _179_1171 = (FStar_SMTEncoding_Term.unboxInt y)
in ((_179_1172), (_179_1171))))
in (FStar_SMTEncoding_Term.mkMul _179_1173))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxInt _179_1174))
in (quant xy _179_1175))
in ((FStar_Syntax_Const.op_Multiply), (_179_1176)))
in (let _179_1231 = (let _179_1230 = (let _179_1185 = (let _179_1184 = (let _179_1183 = (let _179_1182 = (let _179_1181 = (FStar_SMTEncoding_Term.unboxInt x)
in (let _179_1180 = (FStar_SMTEncoding_Term.unboxInt y)
in ((_179_1181), (_179_1180))))
in (FStar_SMTEncoding_Term.mkDiv _179_1182))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxInt _179_1183))
in (quant xy _179_1184))
in ((FStar_Syntax_Const.op_Division), (_179_1185)))
in (let _179_1229 = (let _179_1228 = (let _179_1194 = (let _179_1193 = (let _179_1192 = (let _179_1191 = (let _179_1190 = (FStar_SMTEncoding_Term.unboxInt x)
in (let _179_1189 = (FStar_SMTEncoding_Term.unboxInt y)
in ((_179_1190), (_179_1189))))
in (FStar_SMTEncoding_Term.mkMod _179_1191))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxInt _179_1192))
in (quant xy _179_1193))
in ((FStar_Syntax_Const.op_Modulus), (_179_1194)))
in (let _179_1227 = (let _179_1226 = (let _179_1203 = (let _179_1202 = (let _179_1201 = (let _179_1200 = (let _179_1199 = (FStar_SMTEncoding_Term.unboxBool x)
in (let _179_1198 = (FStar_SMTEncoding_Term.unboxBool y)
in ((_179_1199), (_179_1198))))
in (FStar_SMTEncoding_Term.mkAnd _179_1200))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxBool _179_1201))
in (quant xy _179_1202))
in ((FStar_Syntax_Const.op_And), (_179_1203)))
in (let _179_1225 = (let _179_1224 = (let _179_1212 = (let _179_1211 = (let _179_1210 = (let _179_1209 = (let _179_1208 = (FStar_SMTEncoding_Term.unboxBool x)
in (let _179_1207 = (FStar_SMTEncoding_Term.unboxBool y)
in ((_179_1208), (_179_1207))))
in (FStar_SMTEncoding_Term.mkOr _179_1209))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxBool _179_1210))
in (quant xy _179_1211))
in ((FStar_Syntax_Const.op_Or), (_179_1212)))
in (let _179_1223 = (let _179_1222 = (let _179_1219 = (let _179_1218 = (let _179_1217 = (let _179_1216 = (FStar_SMTEncoding_Term.unboxBool x)
in (FStar_SMTEncoding_Term.mkNot _179_1216))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxBool _179_1217))
in (quant qx _179_1218))
in ((FStar_Syntax_Const.op_Negation), (_179_1219)))
in (_179_1222)::[])
in (_179_1224)::_179_1223))
in (_179_1226)::_179_1225))
in (_179_1228)::_179_1227))
in (_179_1230)::_179_1229))
in (_179_1232)::_179_1231))
in (_179_1234)::_179_1233))
in (_179_1236)::_179_1235))
in (_179_1238)::_179_1237))
in (_179_1240)::_179_1239))
in (_179_1242)::_179_1241))
in (_179_1244)::_179_1243))
in (_179_1246)::_179_1245))
in (_179_1248)::_179_1247))
in (_179_1250)::_179_1249))
in (

let mk = (fun l v -> (let _179_1297 = (let _179_1296 = (FStar_All.pipe_right prims (FStar_List.find (fun _86_1842 -> (match (_86_1842) with
| (l', _86_1841) -> begin
(FStar_Ident.lid_equals l l')
end))))
in (FStar_All.pipe_right _179_1296 (FStar_Option.map (fun _86_1846 -> (match (_86_1846) with
| (_86_1844, b) -> begin
(b v)
end)))))
in (FStar_All.pipe_right _179_1297 FStar_Option.get)))
in (

let is = (fun l -> (FStar_All.pipe_right prims (FStar_Util.for_some (fun _86_1852 -> (match (_86_1852) with
| (l', _86_1851) -> begin
(FStar_Ident.lid_equals l l')
end)))))
in {mk = mk; is = is}))))))))
end))
end))
end))


let pretype_axiom : FStar_SMTEncoding_Term.term  ->  (Prims.string * FStar_SMTEncoding_Term.sort) Prims.list  ->  FStar_SMTEncoding_Term.decl = (fun tapp vars -> (

let _86_1858 = (fresh_fvar "x" FStar_SMTEncoding_Term.Term_sort)
in (match (_86_1858) with
| (xxsym, xx) -> begin
(

let _86_1861 = (fresh_fvar "f" FStar_SMTEncoding_Term.Fuel_sort)
in (match (_86_1861) with
| (ffsym, ff) -> begin
(

let xx_has_type = (FStar_SMTEncoding_Term.mk_HasTypeFuel ff xx tapp)
in (let _179_1327 = (let _179_1326 = (let _179_1321 = (let _179_1320 = (let _179_1319 = (let _179_1318 = (let _179_1317 = (let _179_1316 = (FStar_SMTEncoding_Term.mkApp (("PreType"), ((xx)::[])))
in ((tapp), (_179_1316)))
in (FStar_SMTEncoding_Term.mkEq _179_1317))
in ((xx_has_type), (_179_1318)))
in (FStar_SMTEncoding_Term.mkImp _179_1319))
in ((((xx_has_type)::[])::[]), ((((xxsym), (FStar_SMTEncoding_Term.Term_sort)))::(((ffsym), (FStar_SMTEncoding_Term.Fuel_sort)))::vars), (_179_1320)))
in (FStar_SMTEncoding_Term.mkForall _179_1321))
in (let _179_1325 = (let _179_1324 = (let _179_1323 = (let _179_1322 = (FStar_Util.digest_of_string tapp.FStar_SMTEncoding_Term.hash)
in (Prims.strcat "pretyping_" _179_1322))
in (varops.mk_unique _179_1323))
in Some (_179_1324))
in ((_179_1326), (Some ("pretyping")), (_179_1325))))
in FStar_SMTEncoding_Term.Assume (_179_1327)))
end))
end)))


let primitive_type_axioms : FStar_TypeChecker_Env.env  ->  FStar_Ident.lident  ->  Prims.string  ->  FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.decl Prims.list = (

let xx = (("x"), (FStar_SMTEncoding_Term.Term_sort))
in (

let x = (FStar_SMTEncoding_Term.mkFreeV xx)
in (

let yy = (("y"), (FStar_SMTEncoding_Term.Term_sort))
in (

let y = (FStar_SMTEncoding_Term.mkFreeV yy)
in (

let mk_unit = (fun env nm tt -> (

let typing_pred = (FStar_SMTEncoding_Term.mk_HasType x tt)
in (let _179_1348 = (let _179_1339 = (let _179_1338 = (FStar_SMTEncoding_Term.mk_HasType FStar_SMTEncoding_Term.mk_Term_unit tt)
in ((_179_1338), (Some ("unit typing")), (Some ("unit_typing"))))
in FStar_SMTEncoding_Term.Assume (_179_1339))
in (let _179_1347 = (let _179_1346 = (let _179_1345 = (let _179_1344 = (let _179_1343 = (let _179_1342 = (let _179_1341 = (let _179_1340 = (FStar_SMTEncoding_Term.mkEq ((x), (FStar_SMTEncoding_Term.mk_Term_unit)))
in ((typing_pred), (_179_1340)))
in (FStar_SMTEncoding_Term.mkImp _179_1341))
in ((((typing_pred)::[])::[]), ((xx)::[]), (_179_1342)))
in (mkForall_fuel _179_1343))
in ((_179_1344), (Some ("unit inversion")), (Some ("unit_inversion"))))
in FStar_SMTEncoding_Term.Assume (_179_1345))
in (_179_1346)::[])
in (_179_1348)::_179_1347))))
in (

let mk_bool = (fun env nm tt -> (

let typing_pred = (FStar_SMTEncoding_Term.mk_HasType x tt)
in (

let bb = (("b"), (FStar_SMTEncoding_Term.Bool_sort))
in (

let b = (FStar_SMTEncoding_Term.mkFreeV bb)
in (let _179_1371 = (let _179_1362 = (let _179_1361 = (let _179_1360 = (let _179_1359 = (let _179_1356 = (let _179_1355 = (FStar_SMTEncoding_Term.boxBool b)
in (_179_1355)::[])
in (_179_1356)::[])
in (let _179_1358 = (let _179_1357 = (FStar_SMTEncoding_Term.boxBool b)
in (FStar_SMTEncoding_Term.mk_HasType _179_1357 tt))
in ((_179_1359), ((bb)::[]), (_179_1358))))
in (FStar_SMTEncoding_Term.mkForall _179_1360))
in ((_179_1361), (Some ("bool typing")), (Some ("bool_typing"))))
in FStar_SMTEncoding_Term.Assume (_179_1362))
in (let _179_1370 = (let _179_1369 = (let _179_1368 = (let _179_1367 = (let _179_1366 = (let _179_1365 = (let _179_1364 = (let _179_1363 = (FStar_SMTEncoding_Term.mk_tester "BoxBool" x)
in ((typing_pred), (_179_1363)))
in (FStar_SMTEncoding_Term.mkImp _179_1364))
in ((((typing_pred)::[])::[]), ((xx)::[]), (_179_1365)))
in (mkForall_fuel _179_1366))
in ((_179_1367), (Some ("bool inversion")), (Some ("bool_inversion"))))
in FStar_SMTEncoding_Term.Assume (_179_1368))
in (_179_1369)::[])
in (_179_1371)::_179_1370))))))
in (

let mk_int = (fun env nm tt -> (

let typing_pred = (FStar_SMTEncoding_Term.mk_HasType x tt)
in (

let typing_pred_y = (FStar_SMTEncoding_Term.mk_HasType y tt)
in (

let aa = (("a"), (FStar_SMTEncoding_Term.Int_sort))
in (

let a = (FStar_SMTEncoding_Term.mkFreeV aa)
in (

let bb = (("b"), (FStar_SMTEncoding_Term.Int_sort))
in (

let b = (FStar_SMTEncoding_Term.mkFreeV bb)
in (

let precedes = (let _179_1385 = (let _179_1384 = (let _179_1383 = (let _179_1382 = (let _179_1381 = (let _179_1380 = (FStar_SMTEncoding_Term.boxInt a)
in (let _179_1379 = (let _179_1378 = (FStar_SMTEncoding_Term.boxInt b)
in (_179_1378)::[])
in (_179_1380)::_179_1379))
in (tt)::_179_1381)
in (tt)::_179_1382)
in (("Prims.Precedes"), (_179_1383)))
in (FStar_SMTEncoding_Term.mkApp _179_1384))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.mk_Valid _179_1385))
in (

let precedes_y_x = (let _179_1386 = (FStar_SMTEncoding_Term.mkApp (("Precedes"), ((y)::(x)::[])))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.mk_Valid _179_1386))
in (let _179_1428 = (let _179_1394 = (let _179_1393 = (let _179_1392 = (let _179_1391 = (let _179_1388 = (let _179_1387 = (FStar_SMTEncoding_Term.boxInt b)
in (_179_1387)::[])
in (_179_1388)::[])
in (let _179_1390 = (let _179_1389 = (FStar_SMTEncoding_Term.boxInt b)
in (FStar_SMTEncoding_Term.mk_HasType _179_1389 tt))
in ((_179_1391), ((bb)::[]), (_179_1390))))
in (FStar_SMTEncoding_Term.mkForall _179_1392))
in ((_179_1393), (Some ("int typing")), (Some ("int_typing"))))
in FStar_SMTEncoding_Term.Assume (_179_1394))
in (let _179_1427 = (let _179_1426 = (let _179_1400 = (let _179_1399 = (let _179_1398 = (let _179_1397 = (let _179_1396 = (let _179_1395 = (FStar_SMTEncoding_Term.mk_tester "BoxInt" x)
in ((typing_pred), (_179_1395)))
in (FStar_SMTEncoding_Term.mkImp _179_1396))
in ((((typing_pred)::[])::[]), ((xx)::[]), (_179_1397)))
in (mkForall_fuel _179_1398))
in ((_179_1399), (Some ("int inversion")), (Some ("int_inversion"))))
in FStar_SMTEncoding_Term.Assume (_179_1400))
in (let _179_1425 = (let _179_1424 = (let _179_1423 = (let _179_1422 = (let _179_1421 = (let _179_1420 = (let _179_1419 = (let _179_1418 = (let _179_1417 = (let _179_1416 = (let _179_1415 = (let _179_1414 = (let _179_1403 = (let _179_1402 = (FStar_SMTEncoding_Term.unboxInt x)
in (let _179_1401 = (FStar_SMTEncoding_Term.mkInteger' (Prims.parse_int "0"))
in ((_179_1402), (_179_1401))))
in (FStar_SMTEncoding_Term.mkGT _179_1403))
in (let _179_1413 = (let _179_1412 = (let _179_1406 = (let _179_1405 = (FStar_SMTEncoding_Term.unboxInt y)
in (let _179_1404 = (FStar_SMTEncoding_Term.mkInteger' (Prims.parse_int "0"))
in ((_179_1405), (_179_1404))))
in (FStar_SMTEncoding_Term.mkGTE _179_1406))
in (let _179_1411 = (let _179_1410 = (let _179_1409 = (let _179_1408 = (FStar_SMTEncoding_Term.unboxInt y)
in (let _179_1407 = (FStar_SMTEncoding_Term.unboxInt x)
in ((_179_1408), (_179_1407))))
in (FStar_SMTEncoding_Term.mkLT _179_1409))
in (_179_1410)::[])
in (_179_1412)::_179_1411))
in (_179_1414)::_179_1413))
in (typing_pred_y)::_179_1415)
in (typing_pred)::_179_1416)
in (FStar_SMTEncoding_Term.mk_and_l _179_1417))
in ((_179_1418), (precedes_y_x)))
in (FStar_SMTEncoding_Term.mkImp _179_1419))
in ((((typing_pred)::(typing_pred_y)::(precedes_y_x)::[])::[]), ((xx)::(yy)::[]), (_179_1420)))
in (mkForall_fuel _179_1421))
in ((_179_1422), (Some ("well-founded ordering on nat (alt)")), (Some ("well-founded-ordering-on-nat"))))
in FStar_SMTEncoding_Term.Assume (_179_1423))
in (_179_1424)::[])
in (_179_1426)::_179_1425))
in (_179_1428)::_179_1427)))))))))))
in (

let mk_str = (fun env nm tt -> (

let typing_pred = (FStar_SMTEncoding_Term.mk_HasType x tt)
in (

let bb = (("b"), (FStar_SMTEncoding_Term.String_sort))
in (

let b = (FStar_SMTEncoding_Term.mkFreeV bb)
in (let _179_1451 = (let _179_1442 = (let _179_1441 = (let _179_1440 = (let _179_1439 = (let _179_1436 = (let _179_1435 = (FStar_SMTEncoding_Term.boxString b)
in (_179_1435)::[])
in (_179_1436)::[])
in (let _179_1438 = (let _179_1437 = (FStar_SMTEncoding_Term.boxString b)
in (FStar_SMTEncoding_Term.mk_HasType _179_1437 tt))
in ((_179_1439), ((bb)::[]), (_179_1438))))
in (FStar_SMTEncoding_Term.mkForall _179_1440))
in ((_179_1441), (Some ("string typing")), (Some ("string_typing"))))
in FStar_SMTEncoding_Term.Assume (_179_1442))
in (let _179_1450 = (let _179_1449 = (let _179_1448 = (let _179_1447 = (let _179_1446 = (let _179_1445 = (let _179_1444 = (let _179_1443 = (FStar_SMTEncoding_Term.mk_tester "BoxString" x)
in ((typing_pred), (_179_1443)))
in (FStar_SMTEncoding_Term.mkImp _179_1444))
in ((((typing_pred)::[])::[]), ((xx)::[]), (_179_1445)))
in (mkForall_fuel _179_1446))
in ((_179_1447), (Some ("string inversion")), (Some ("string_inversion"))))
in FStar_SMTEncoding_Term.Assume (_179_1448))
in (_179_1449)::[])
in (_179_1451)::_179_1450))))))
in (

let mk_ref = (fun env reft_name _86_1900 -> (

let r = (("r"), (FStar_SMTEncoding_Term.Ref_sort))
in (

let aa = (("a"), (FStar_SMTEncoding_Term.Term_sort))
in (

let bb = (("b"), (FStar_SMTEncoding_Term.Term_sort))
in (

let refa = (let _179_1460 = (let _179_1459 = (let _179_1458 = (FStar_SMTEncoding_Term.mkFreeV aa)
in (_179_1458)::[])
in ((reft_name), (_179_1459)))
in (FStar_SMTEncoding_Term.mkApp _179_1460))
in (

let refb = (let _179_1463 = (let _179_1462 = (let _179_1461 = (FStar_SMTEncoding_Term.mkFreeV bb)
in (_179_1461)::[])
in ((reft_name), (_179_1462)))
in (FStar_SMTEncoding_Term.mkApp _179_1463))
in (

let typing_pred = (FStar_SMTEncoding_Term.mk_HasType x refa)
in (

let typing_pred_b = (FStar_SMTEncoding_Term.mk_HasType x refb)
in (let _179_1482 = (let _179_1469 = (let _179_1468 = (let _179_1467 = (let _179_1466 = (let _179_1465 = (let _179_1464 = (FStar_SMTEncoding_Term.mk_tester "BoxRef" x)
in ((typing_pred), (_179_1464)))
in (FStar_SMTEncoding_Term.mkImp _179_1465))
in ((((typing_pred)::[])::[]), ((xx)::(aa)::[]), (_179_1466)))
in (mkForall_fuel _179_1467))
in ((_179_1468), (Some ("ref inversion")), (Some ("ref_inversion"))))
in FStar_SMTEncoding_Term.Assume (_179_1469))
in (let _179_1481 = (let _179_1480 = (let _179_1479 = (let _179_1478 = (let _179_1477 = (let _179_1476 = (let _179_1475 = (let _179_1474 = (FStar_SMTEncoding_Term.mkAnd ((typing_pred), (typing_pred_b)))
in (let _179_1473 = (let _179_1472 = (let _179_1471 = (FStar_SMTEncoding_Term.mkFreeV aa)
in (let _179_1470 = (FStar_SMTEncoding_Term.mkFreeV bb)
in ((_179_1471), (_179_1470))))
in (FStar_SMTEncoding_Term.mkEq _179_1472))
in ((_179_1474), (_179_1473))))
in (FStar_SMTEncoding_Term.mkImp _179_1475))
in ((((typing_pred)::(typing_pred_b)::[])::[]), ((xx)::(aa)::(bb)::[]), (_179_1476)))
in (mkForall_fuel' (Prims.parse_int "2") _179_1477))
in ((_179_1478), (Some ("ref typing is injective")), (Some ("ref_injectivity"))))
in FStar_SMTEncoding_Term.Assume (_179_1479))
in (_179_1480)::[])
in (_179_1482)::_179_1481))))))))))
in (

let mk_false_interp = (fun env nm false_tm -> (

let valid = (FStar_SMTEncoding_Term.mkApp (("Valid"), ((false_tm)::[])))
in (let _179_1491 = (let _179_1490 = (let _179_1489 = (FStar_SMTEncoding_Term.mkIff ((FStar_SMTEncoding_Term.mkFalse), (valid)))
in ((_179_1489), (Some ("False interpretation")), (Some ("false_interp"))))
in FStar_SMTEncoding_Term.Assume (_179_1490))
in (_179_1491)::[])))
in (

let mk_and_interp = (fun env conj _86_1917 -> (

let aa = (("a"), (FStar_SMTEncoding_Term.Term_sort))
in (

let bb = (("b"), (FStar_SMTEncoding_Term.Term_sort))
in (

let a = (FStar_SMTEncoding_Term.mkFreeV aa)
in (

let b = (FStar_SMTEncoding_Term.mkFreeV bb)
in (

let valid = (let _179_1500 = (let _179_1499 = (let _179_1498 = (FStar_SMTEncoding_Term.mkApp ((conj), ((a)::(b)::[])))
in (_179_1498)::[])
in (("Valid"), (_179_1499)))
in (FStar_SMTEncoding_Term.mkApp _179_1500))
in (

let valid_a = (FStar_SMTEncoding_Term.mkApp (("Valid"), ((a)::[])))
in (

let valid_b = (FStar_SMTEncoding_Term.mkApp (("Valid"), ((b)::[])))
in (let _179_1507 = (let _179_1506 = (let _179_1505 = (let _179_1504 = (let _179_1503 = (let _179_1502 = (let _179_1501 = (FStar_SMTEncoding_Term.mkAnd ((valid_a), (valid_b)))
in ((_179_1501), (valid)))
in (FStar_SMTEncoding_Term.mkIff _179_1502))
in ((((valid)::[])::[]), ((aa)::(bb)::[]), (_179_1503)))
in (FStar_SMTEncoding_Term.mkForall _179_1504))
in ((_179_1505), (Some ("/\\ interpretation")), (Some ("l_and-interp"))))
in FStar_SMTEncoding_Term.Assume (_179_1506))
in (_179_1507)::[])))))))))
in (

let mk_or_interp = (fun env disj _86_1929 -> (

let aa = (("a"), (FStar_SMTEncoding_Term.Term_sort))
in (

let bb = (("b"), (FStar_SMTEncoding_Term.Term_sort))
in (

let a = (FStar_SMTEncoding_Term.mkFreeV aa)
in (

let b = (FStar_SMTEncoding_Term.mkFreeV bb)
in (

let valid = (let _179_1516 = (let _179_1515 = (let _179_1514 = (FStar_SMTEncoding_Term.mkApp ((disj), ((a)::(b)::[])))
in (_179_1514)::[])
in (("Valid"), (_179_1515)))
in (FStar_SMTEncoding_Term.mkApp _179_1516))
in (

let valid_a = (FStar_SMTEncoding_Term.mkApp (("Valid"), ((a)::[])))
in (

let valid_b = (FStar_SMTEncoding_Term.mkApp (("Valid"), ((b)::[])))
in (let _179_1523 = (let _179_1522 = (let _179_1521 = (let _179_1520 = (let _179_1519 = (let _179_1518 = (let _179_1517 = (FStar_SMTEncoding_Term.mkOr ((valid_a), (valid_b)))
in ((_179_1517), (valid)))
in (FStar_SMTEncoding_Term.mkIff _179_1518))
in ((((valid)::[])::[]), ((aa)::(bb)::[]), (_179_1519)))
in (FStar_SMTEncoding_Term.mkForall _179_1520))
in ((_179_1521), (Some ("\\/ interpretation")), (Some ("l_or-interp"))))
in FStar_SMTEncoding_Term.Assume (_179_1522))
in (_179_1523)::[])))))))))
in (

let mk_eq2_interp = (fun env eq2 tt -> (

let aa = (("a"), (FStar_SMTEncoding_Term.Term_sort))
in (

let xx = (("x"), (FStar_SMTEncoding_Term.Term_sort))
in (

let yy = (("y"), (FStar_SMTEncoding_Term.Term_sort))
in (

let a = (FStar_SMTEncoding_Term.mkFreeV aa)
in (

let x = (FStar_SMTEncoding_Term.mkFreeV xx)
in (

let y = (FStar_SMTEncoding_Term.mkFreeV yy)
in (

let valid = (let _179_1532 = (let _179_1531 = (let _179_1530 = (FStar_SMTEncoding_Term.mkApp ((eq2), ((a)::(x)::(y)::[])))
in (_179_1530)::[])
in (("Valid"), (_179_1531)))
in (FStar_SMTEncoding_Term.mkApp _179_1532))
in (let _179_1539 = (let _179_1538 = (let _179_1537 = (let _179_1536 = (let _179_1535 = (let _179_1534 = (let _179_1533 = (FStar_SMTEncoding_Term.mkEq ((x), (y)))
in ((_179_1533), (valid)))
in (FStar_SMTEncoding_Term.mkIff _179_1534))
in ((((valid)::[])::[]), ((aa)::(xx)::(yy)::[]), (_179_1535)))
in (FStar_SMTEncoding_Term.mkForall _179_1536))
in ((_179_1537), (Some ("Eq2 interpretation")), (Some ("eq2-interp"))))
in FStar_SMTEncoding_Term.Assume (_179_1538))
in (_179_1539)::[])))))))))
in (

let mk_eq3_interp = (fun env eq3 tt -> (

let aa = (("a"), (FStar_SMTEncoding_Term.Term_sort))
in (

let bb = (("b"), (FStar_SMTEncoding_Term.Term_sort))
in (

let xx = (("x"), (FStar_SMTEncoding_Term.Term_sort))
in (

let yy = (("y"), (FStar_SMTEncoding_Term.Term_sort))
in (

let a = (FStar_SMTEncoding_Term.mkFreeV aa)
in (

let b = (FStar_SMTEncoding_Term.mkFreeV bb)
in (

let x = (FStar_SMTEncoding_Term.mkFreeV xx)
in (

let y = (FStar_SMTEncoding_Term.mkFreeV yy)
in (

let valid = (let _179_1548 = (let _179_1547 = (let _179_1546 = (FStar_SMTEncoding_Term.mkApp ((eq3), ((a)::(b)::(x)::(y)::[])))
in (_179_1546)::[])
in (("Valid"), (_179_1547)))
in (FStar_SMTEncoding_Term.mkApp _179_1548))
in (let _179_1555 = (let _179_1554 = (let _179_1553 = (let _179_1552 = (let _179_1551 = (let _179_1550 = (let _179_1549 = (FStar_SMTEncoding_Term.mkEq ((x), (y)))
in ((_179_1549), (valid)))
in (FStar_SMTEncoding_Term.mkIff _179_1550))
in ((((valid)::[])::[]), ((aa)::(bb)::(xx)::(yy)::[]), (_179_1551)))
in (FStar_SMTEncoding_Term.mkForall _179_1552))
in ((_179_1553), (Some ("Eq3 interpretation")), (Some ("eq3-interp"))))
in FStar_SMTEncoding_Term.Assume (_179_1554))
in (_179_1555)::[])))))))))))
in (

let mk_imp_interp = (fun env imp tt -> (

let aa = (("a"), (FStar_SMTEncoding_Term.Term_sort))
in (

let bb = (("b"), (FStar_SMTEncoding_Term.Term_sort))
in (

let a = (FStar_SMTEncoding_Term.mkFreeV aa)
in (

let b = (FStar_SMTEncoding_Term.mkFreeV bb)
in (

let valid = (let _179_1564 = (let _179_1563 = (let _179_1562 = (FStar_SMTEncoding_Term.mkApp ((imp), ((a)::(b)::[])))
in (_179_1562)::[])
in (("Valid"), (_179_1563)))
in (FStar_SMTEncoding_Term.mkApp _179_1564))
in (

let valid_a = (FStar_SMTEncoding_Term.mkApp (("Valid"), ((a)::[])))
in (

let valid_b = (FStar_SMTEncoding_Term.mkApp (("Valid"), ((b)::[])))
in (let _179_1571 = (let _179_1570 = (let _179_1569 = (let _179_1568 = (let _179_1567 = (let _179_1566 = (let _179_1565 = (FStar_SMTEncoding_Term.mkImp ((valid_a), (valid_b)))
in ((_179_1565), (valid)))
in (FStar_SMTEncoding_Term.mkIff _179_1566))
in ((((valid)::[])::[]), ((aa)::(bb)::[]), (_179_1567)))
in (FStar_SMTEncoding_Term.mkForall _179_1568))
in ((_179_1569), (Some ("==> interpretation")), (Some ("l_imp-interp"))))
in FStar_SMTEncoding_Term.Assume (_179_1570))
in (_179_1571)::[])))))))))
in (

let mk_iff_interp = (fun env iff tt -> (

let aa = (("a"), (FStar_SMTEncoding_Term.Term_sort))
in (

let bb = (("b"), (FStar_SMTEncoding_Term.Term_sort))
in (

let a = (FStar_SMTEncoding_Term.mkFreeV aa)
in (

let b = (FStar_SMTEncoding_Term.mkFreeV bb)
in (

let valid = (let _179_1580 = (let _179_1579 = (let _179_1578 = (FStar_SMTEncoding_Term.mkApp ((iff), ((a)::(b)::[])))
in (_179_1578)::[])
in (("Valid"), (_179_1579)))
in (FStar_SMTEncoding_Term.mkApp _179_1580))
in (

let valid_a = (FStar_SMTEncoding_Term.mkApp (("Valid"), ((a)::[])))
in (

let valid_b = (FStar_SMTEncoding_Term.mkApp (("Valid"), ((b)::[])))
in (let _179_1587 = (let _179_1586 = (let _179_1585 = (let _179_1584 = (let _179_1583 = (let _179_1582 = (let _179_1581 = (FStar_SMTEncoding_Term.mkIff ((valid_a), (valid_b)))
in ((_179_1581), (valid)))
in (FStar_SMTEncoding_Term.mkIff _179_1582))
in ((((valid)::[])::[]), ((aa)::(bb)::[]), (_179_1583)))
in (FStar_SMTEncoding_Term.mkForall _179_1584))
in ((_179_1585), (Some ("<==> interpretation")), (Some ("l_iff-interp"))))
in FStar_SMTEncoding_Term.Assume (_179_1586))
in (_179_1587)::[])))))))))
in (

let mk_forall_interp = (fun env for_all tt -> (

let aa = (("a"), (FStar_SMTEncoding_Term.Term_sort))
in (

let bb = (("b"), (FStar_SMTEncoding_Term.Term_sort))
in (

let xx = (("x"), (FStar_SMTEncoding_Term.Term_sort))
in (

let a = (FStar_SMTEncoding_Term.mkFreeV aa)
in (

let b = (FStar_SMTEncoding_Term.mkFreeV bb)
in (

let x = (FStar_SMTEncoding_Term.mkFreeV xx)
in (

let valid = (let _179_1596 = (let _179_1595 = (let _179_1594 = (FStar_SMTEncoding_Term.mkApp ((for_all), ((a)::(b)::[])))
in (_179_1594)::[])
in (("Valid"), (_179_1595)))
in (FStar_SMTEncoding_Term.mkApp _179_1596))
in (

let valid_b_x = (let _179_1599 = (let _179_1598 = (let _179_1597 = (FStar_SMTEncoding_Term.mk_ApplyTT b x)
in (_179_1597)::[])
in (("Valid"), (_179_1598)))
in (FStar_SMTEncoding_Term.mkApp _179_1599))
in (let _179_1613 = (let _179_1612 = (let _179_1611 = (let _179_1610 = (let _179_1609 = (let _179_1608 = (let _179_1607 = (let _179_1606 = (let _179_1605 = (let _179_1601 = (let _179_1600 = (FStar_SMTEncoding_Term.mk_HasTypeZ x a)
in (_179_1600)::[])
in (_179_1601)::[])
in (let _179_1604 = (let _179_1603 = (let _179_1602 = (FStar_SMTEncoding_Term.mk_HasTypeZ x a)
in ((_179_1602), (valid_b_x)))
in (FStar_SMTEncoding_Term.mkImp _179_1603))
in ((_179_1605), ((xx)::[]), (_179_1604))))
in (FStar_SMTEncoding_Term.mkForall _179_1606))
in ((_179_1607), (valid)))
in (FStar_SMTEncoding_Term.mkIff _179_1608))
in ((((valid)::[])::[]), ((aa)::(bb)::[]), (_179_1609)))
in (FStar_SMTEncoding_Term.mkForall _179_1610))
in ((_179_1611), (Some ("forall interpretation")), (Some ("forall-interp"))))
in FStar_SMTEncoding_Term.Assume (_179_1612))
in (_179_1613)::[]))))))))))
in (

let mk_exists_interp = (fun env for_some tt -> (

let aa = (("a"), (FStar_SMTEncoding_Term.Term_sort))
in (

let bb = (("b"), (FStar_SMTEncoding_Term.Term_sort))
in (

let xx = (("x"), (FStar_SMTEncoding_Term.Term_sort))
in (

let a = (FStar_SMTEncoding_Term.mkFreeV aa)
in (

let b = (FStar_SMTEncoding_Term.mkFreeV bb)
in (

let x = (FStar_SMTEncoding_Term.mkFreeV xx)
in (

let valid = (let _179_1622 = (let _179_1621 = (let _179_1620 = (FStar_SMTEncoding_Term.mkApp ((for_some), ((a)::(b)::[])))
in (_179_1620)::[])
in (("Valid"), (_179_1621)))
in (FStar_SMTEncoding_Term.mkApp _179_1622))
in (

let valid_b_x = (let _179_1625 = (let _179_1624 = (let _179_1623 = (FStar_SMTEncoding_Term.mk_ApplyTT b x)
in (_179_1623)::[])
in (("Valid"), (_179_1624)))
in (FStar_SMTEncoding_Term.mkApp _179_1625))
in (let _179_1639 = (let _179_1638 = (let _179_1637 = (let _179_1636 = (let _179_1635 = (let _179_1634 = (let _179_1633 = (let _179_1632 = (let _179_1631 = (let _179_1627 = (let _179_1626 = (FStar_SMTEncoding_Term.mk_HasTypeZ x a)
in (_179_1626)::[])
in (_179_1627)::[])
in (let _179_1630 = (let _179_1629 = (let _179_1628 = (FStar_SMTEncoding_Term.mk_HasTypeZ x a)
in ((_179_1628), (valid_b_x)))
in (FStar_SMTEncoding_Term.mkImp _179_1629))
in ((_179_1631), ((xx)::[]), (_179_1630))))
in (FStar_SMTEncoding_Term.mkExists _179_1632))
in ((_179_1633), (valid)))
in (FStar_SMTEncoding_Term.mkIff _179_1634))
in ((((valid)::[])::[]), ((aa)::(bb)::[]), (_179_1635)))
in (FStar_SMTEncoding_Term.mkForall _179_1636))
in ((_179_1637), (Some ("exists interpretation")), (Some ("exists-interp"))))
in FStar_SMTEncoding_Term.Assume (_179_1638))
in (_179_1639)::[]))))))))))
in (

let mk_range_interp = (fun env range tt -> (

let range_ty = (FStar_SMTEncoding_Term.mkApp ((range), ([])))
in (let _179_1650 = (let _179_1649 = (let _179_1648 = (FStar_SMTEncoding_Term.mk_HasTypeZ FStar_SMTEncoding_Term.mk_Range_const range_ty)
in (let _179_1647 = (let _179_1646 = (varops.mk_unique "typing_range_const")
in Some (_179_1646))
in ((_179_1648), (Some ("Range_const typing")), (_179_1647))))
in FStar_SMTEncoding_Term.Assume (_179_1649))
in (_179_1650)::[])))
in (

let prims = (((FStar_Syntax_Const.unit_lid), (mk_unit)))::(((FStar_Syntax_Const.bool_lid), (mk_bool)))::(((FStar_Syntax_Const.int_lid), (mk_int)))::(((FStar_Syntax_Const.string_lid), (mk_str)))::(((FStar_Syntax_Const.ref_lid), (mk_ref)))::(((FStar_Syntax_Const.false_lid), (mk_false_interp)))::(((FStar_Syntax_Const.and_lid), (mk_and_interp)))::(((FStar_Syntax_Const.or_lid), (mk_or_interp)))::(((FStar_Syntax_Const.eq2_lid), (mk_eq2_interp)))::(((FStar_Syntax_Const.eq3_lid), (mk_eq3_interp)))::(((FStar_Syntax_Const.imp_lid), (mk_imp_interp)))::(((FStar_Syntax_Const.iff_lid), (mk_iff_interp)))::(((FStar_Syntax_Const.forall_lid), (mk_forall_interp)))::(((FStar_Syntax_Const.exists_lid), (mk_exists_interp)))::(((FStar_Syntax_Const.range_lid), (mk_range_interp)))::[]
in (fun env t s tt -> (match ((FStar_Util.find_opt (fun _86_2022 -> (match (_86_2022) with
| (l, _86_2021) -> begin
(FStar_Ident.lid_equals l t)
end)) prims)) with
| None -> begin
[]
end
| Some (_86_2025, f) -> begin
(f env s tt)
end))))))))))))))))))))))


let encode_smt_lemma : env_t  ->  FStar_Syntax_Syntax.fv  ->  FStar_Syntax_Syntax.typ  ->  FStar_SMTEncoding_Term.decl Prims.list = (fun env fv t -> (

let lid = fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v
in (

let _86_2035 = (encode_function_type_as_formula None None t env)
in (match (_86_2035) with
| (form, decls) -> begin
(FStar_List.append decls ((FStar_SMTEncoding_Term.Assume (((form), (Some ((Prims.strcat "Lemma: " lid.FStar_Ident.str))), (Some ((Prims.strcat "lemma_" lid.FStar_Ident.str))))))::[]))
end))))


let encode_free_var : env_t  ->  FStar_Syntax_Syntax.fv  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.qualifier Prims.list  ->  (FStar_SMTEncoding_Term.decl Prims.list * env_t) = (fun env fv tt t_norm quals -> (

let lid = fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v
in if ((let _179_1849 = (FStar_Syntax_Util.is_pure_or_ghost_function t_norm)
in (FStar_All.pipe_left Prims.op_Negation _179_1849)) || (FStar_Syntax_Util.is_lemma t_norm)) then begin
(

let _86_2045 = (new_term_constant_and_tok_from_lid env lid)
in (match (_86_2045) with
| (vname, vtok, env) -> begin
(

let arg_sorts = (match ((let _179_1850 = (FStar_Syntax_Subst.compress t_norm)
in _179_1850.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (binders, _86_2048) -> begin
(FStar_All.pipe_right binders (FStar_List.map (fun _86_2051 -> FStar_SMTEncoding_Term.Term_sort)))
end
| _86_2054 -> begin
[]
end)
in (

let d = FStar_SMTEncoding_Term.DeclFun (((vname), (arg_sorts), (FStar_SMTEncoding_Term.Term_sort), (Some ("Uninterpreted function symbol for impure function"))))
in (

let dd = FStar_SMTEncoding_Term.DeclFun (((vtok), ([]), (FStar_SMTEncoding_Term.Term_sort), (Some ("Uninterpreted name for impure function"))))
in (((d)::(dd)::[]), (env)))))
end))
end else begin
if (prims.is lid) then begin
(

let vname = (varops.new_fvar lid)
in (

let _86_2061 = (prims.mk lid vname)
in (match (_86_2061) with
| (tok, definition) -> begin
(

let env = (push_free_var env lid vname (Some (tok)))
in ((definition), (env)))
end)))
end else begin
(

let encode_non_total_function_typ = (lid.FStar_Ident.nsstr <> "Prims")
in (

let _86_2071 = (

let _86_2066 = (curried_arrow_formals_comp t_norm)
in (match (_86_2066) with
| (args, comp) -> begin
if encode_non_total_function_typ then begin
(let _179_1852 = (FStar_TypeChecker_Util.pure_or_ghost_pre_and_post env.tcenv comp)
in ((args), (_179_1852)))
end else begin
((args), (((None), ((FStar_Syntax_Util.comp_result comp)))))
end
end))
in (match (_86_2071) with
| (formals, (pre_opt, res_t)) -> begin
(

let _86_2075 = (new_term_constant_and_tok_from_lid env lid)
in (match (_86_2075) with
| (vname, vtok, env) -> begin
(

let vtok_tm = (match (formals) with
| [] -> begin
(FStar_SMTEncoding_Term.mkFreeV ((vname), (FStar_SMTEncoding_Term.Term_sort)))
end
| _86_2078 -> begin
(FStar_SMTEncoding_Term.mkApp ((vtok), ([])))
end)
in (

let mk_disc_proj_axioms = (fun guard encoded_res_t vapp vars -> (FStar_All.pipe_right quals (FStar_List.collect (fun _86_14 -> (match (_86_14) with
| FStar_Syntax_Syntax.Discriminator (d) -> begin
(

let _86_2094 = (FStar_Util.prefix vars)
in (match (_86_2094) with
| (_86_2089, (xxsym, _86_2092)) -> begin
(

let xx = (FStar_SMTEncoding_Term.mkFreeV ((xxsym), (FStar_SMTEncoding_Term.Term_sort)))
in (let _179_1869 = (let _179_1868 = (let _179_1867 = (let _179_1866 = (let _179_1865 = (let _179_1864 = (let _179_1863 = (let _179_1862 = (FStar_SMTEncoding_Term.mk_tester (escape d.FStar_Ident.str) xx)
in (FStar_All.pipe_left FStar_SMTEncoding_Term.boxBool _179_1862))
in ((vapp), (_179_1863)))
in (FStar_SMTEncoding_Term.mkEq _179_1864))
in ((((vapp)::[])::[]), (vars), (_179_1865)))
in (FStar_SMTEncoding_Term.mkForall _179_1866))
in ((_179_1867), (Some ("Discriminator equation")), (Some ((Prims.strcat "disc_equation_" (escape d.FStar_Ident.str))))))
in FStar_SMTEncoding_Term.Assume (_179_1868))
in (_179_1869)::[]))
end))
end
| FStar_Syntax_Syntax.Projector (d, f) -> begin
(

let _86_2106 = (FStar_Util.prefix vars)
in (match (_86_2106) with
| (_86_2101, (xxsym, _86_2104)) -> begin
(

let xx = (FStar_SMTEncoding_Term.mkFreeV ((xxsym), (FStar_SMTEncoding_Term.Term_sort)))
in (

let f = {FStar_Syntax_Syntax.ppname = f; FStar_Syntax_Syntax.index = (Prims.parse_int "0"); FStar_Syntax_Syntax.sort = FStar_Syntax_Syntax.tun}
in (

let tp_name = (mk_term_projector_name d f)
in (

let prim_app = (FStar_SMTEncoding_Term.mkApp ((tp_name), ((xx)::[])))
in (let _179_1874 = (let _179_1873 = (let _179_1872 = (let _179_1871 = (let _179_1870 = (FStar_SMTEncoding_Term.mkEq ((vapp), (prim_app)))
in ((((vapp)::[])::[]), (vars), (_179_1870)))
in (FStar_SMTEncoding_Term.mkForall _179_1871))
in ((_179_1872), (Some ("Projector equation")), (Some ((Prims.strcat "proj_equation_" tp_name)))))
in FStar_SMTEncoding_Term.Assume (_179_1873))
in (_179_1874)::[])))))
end))
end
| _86_2112 -> begin
[]
end)))))
in (

let _86_2119 = (encode_binders None formals env)
in (match (_86_2119) with
| (vars, guards, env', decls1, _86_2118) -> begin
(

let _86_2128 = (match (pre_opt) with
| None -> begin
(let _179_1875 = (FStar_SMTEncoding_Term.mk_and_l guards)
in ((_179_1875), (decls1)))
end
| Some (p) -> begin
(

let _86_2125 = (encode_formula p env')
in (match (_86_2125) with
| (g, ds) -> begin
(let _179_1876 = (FStar_SMTEncoding_Term.mk_and_l ((g)::guards))
in ((_179_1876), ((FStar_List.append decls1 ds))))
end))
end)
in (match (_86_2128) with
| (guard, decls1) -> begin
(

let vtok_app = (mk_Apply vtok_tm vars)
in (

let vapp = (let _179_1878 = (let _179_1877 = (FStar_List.map FStar_SMTEncoding_Term.mkFreeV vars)
in ((vname), (_179_1877)))
in (FStar_SMTEncoding_Term.mkApp _179_1878))
in (

let _86_2152 = (

let vname_decl = (let _179_1881 = (let _179_1880 = (FStar_All.pipe_right formals (FStar_List.map (fun _86_2131 -> FStar_SMTEncoding_Term.Term_sort)))
in ((vname), (_179_1880), (FStar_SMTEncoding_Term.Term_sort), (None)))
in FStar_SMTEncoding_Term.DeclFun (_179_1881))
in (

let _86_2139 = (

let env = (

let _86_2134 = env
in {bindings = _86_2134.bindings; depth = _86_2134.depth; tcenv = _86_2134.tcenv; warn = _86_2134.warn; cache = _86_2134.cache; nolabels = _86_2134.nolabels; use_zfuel_name = _86_2134.use_zfuel_name; encode_non_total_function_typ = encode_non_total_function_typ})
in if (not ((head_normal env tt))) then begin
(encode_term_pred None tt env vtok_tm)
end else begin
(encode_term_pred None t_norm env vtok_tm)
end)
in (match (_86_2139) with
| (tok_typing, decls2) -> begin
(

let tok_typing = FStar_SMTEncoding_Term.Assume (((tok_typing), (Some ("function token typing")), (Some ((Prims.strcat "function_token_typing_" vname)))))
in (

let _86_2149 = (match (formals) with
| [] -> begin
(let _179_1885 = (let _179_1884 = (let _179_1883 = (FStar_SMTEncoding_Term.mkFreeV ((vname), (FStar_SMTEncoding_Term.Term_sort)))
in (FStar_All.pipe_left (fun _179_1882 -> Some (_179_1882)) _179_1883))
in (push_free_var env lid vname _179_1884))
in (((FStar_List.append decls2 ((tok_typing)::[]))), (_179_1885)))
end
| _86_2143 -> begin
(

let vtok_decl = FStar_SMTEncoding_Term.DeclFun (((vtok), ([]), (FStar_SMTEncoding_Term.Term_sort), (None)))
in (

let vtok_fresh = (let _179_1886 = (varops.next_id ())
in (FStar_SMTEncoding_Term.fresh_token ((vtok), (FStar_SMTEncoding_Term.Term_sort)) _179_1886))
in (

let name_tok_corr = (let _179_1890 = (let _179_1889 = (let _179_1888 = (let _179_1887 = (FStar_SMTEncoding_Term.mkEq ((vtok_app), (vapp)))
in ((((vtok_app)::[])::((vapp)::[])::[]), (vars), (_179_1887)))
in (FStar_SMTEncoding_Term.mkForall _179_1888))
in ((_179_1889), (Some ("Name-token correspondence")), (Some ((Prims.strcat "token_correspondence_" vname)))))
in FStar_SMTEncoding_Term.Assume (_179_1890))
in (((FStar_List.append decls2 ((vtok_decl)::(vtok_fresh)::(name_tok_corr)::(tok_typing)::[]))), (env)))))
end)
in (match (_86_2149) with
| (tok_decl, env) -> begin
(((vname_decl)::tok_decl), (env))
end)))
end)))
in (match (_86_2152) with
| (decls2, env) -> begin
(

let _86_2160 = (

let res_t = (FStar_Syntax_Subst.compress res_t)
in (

let _86_2156 = (encode_term res_t env')
in (match (_86_2156) with
| (encoded_res_t, decls) -> begin
(let _179_1891 = (FStar_SMTEncoding_Term.mk_HasType vapp encoded_res_t)
in ((encoded_res_t), (_179_1891), (decls)))
end)))
in (match (_86_2160) with
| (encoded_res_t, ty_pred, decls3) -> begin
(

let typingAx = (let _179_1895 = (let _179_1894 = (let _179_1893 = (let _179_1892 = (FStar_SMTEncoding_Term.mkImp ((guard), (ty_pred)))
in ((((vapp)::[])::[]), (vars), (_179_1892)))
in (FStar_SMTEncoding_Term.mkForall _179_1893))
in ((_179_1894), (Some ("free var typing")), (Some ((Prims.strcat "typing_" vname)))))
in FStar_SMTEncoding_Term.Assume (_179_1895))
in (

let freshness = if (FStar_All.pipe_right quals (FStar_List.contains FStar_Syntax_Syntax.New)) then begin
(let _179_1901 = (let _179_1898 = (let _179_1897 = (FStar_All.pipe_right vars (FStar_List.map Prims.snd))
in (let _179_1896 = (varops.next_id ())
in ((vname), (_179_1897), (FStar_SMTEncoding_Term.Term_sort), (_179_1896))))
in (FStar_SMTEncoding_Term.fresh_constructor _179_1898))
in (let _179_1900 = (let _179_1899 = (pretype_axiom vapp vars)
in (_179_1899)::[])
in (_179_1901)::_179_1900))
end else begin
[]
end
in (

let g = (let _179_1906 = (let _179_1905 = (let _179_1904 = (let _179_1903 = (let _179_1902 = (mk_disc_proj_axioms guard encoded_res_t vapp vars)
in (typingAx)::_179_1902)
in (FStar_List.append freshness _179_1903))
in (FStar_List.append decls3 _179_1904))
in (FStar_List.append decls2 _179_1905))
in (FStar_List.append decls1 _179_1906))
in ((g), (env)))))
end))
end))))
end))
end))))
end))
end)))
end
end))


let declare_top_level_let : env_t  ->  FStar_Syntax_Syntax.fv  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term  ->  ((Prims.string * FStar_SMTEncoding_Term.term Prims.option) * FStar_SMTEncoding_Term.decl Prims.list * env_t) = (fun env x t t_norm -> (match ((try_lookup_lid env x.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)) with
| None -> begin
(

let _86_2171 = (encode_free_var env x t t_norm [])
in (match (_86_2171) with
| (decls, env) -> begin
(

let _86_2176 = (lookup_lid env x.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)
in (match (_86_2176) with
| (n, x', _86_2175) -> begin
((((n), (x'))), (decls), (env))
end))
end))
end
| Some (n, x, _86_2180) -> begin
((((n), (x))), ([]), (env))
end))


let encode_top_level_val : env_t  ->  FStar_Syntax_Syntax.fv  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.qualifier Prims.list  ->  (FStar_SMTEncoding_Term.decl Prims.list * env_t) = (fun env lid t quals -> (

let tt = (norm env t)
in (

let _86_2190 = (encode_free_var env lid t tt quals)
in (match (_86_2190) with
| (decls, env) -> begin
if (FStar_Syntax_Util.is_smt_lemma t) then begin
(let _179_1924 = (let _179_1923 = (encode_smt_lemma env lid tt)
in (FStar_List.append decls _179_1923))
in ((_179_1924), (env)))
end else begin
((decls), (env))
end
end))))


let encode_top_level_vals : env_t  ->  FStar_Syntax_Syntax.letbinding Prims.list  ->  FStar_Syntax_Syntax.qualifier Prims.list  ->  (FStar_SMTEncoding_Term.decl Prims.list * env_t) = (fun env bindings quals -> (FStar_All.pipe_right bindings (FStar_List.fold_left (fun _86_2196 lb -> (match (_86_2196) with
| (decls, env) -> begin
(

let _86_2200 = (let _179_1933 = (FStar_Util.right lb.FStar_Syntax_Syntax.lbname)
in (encode_top_level_val env _179_1933 lb.FStar_Syntax_Syntax.lbtyp quals))
in (match (_86_2200) with
| (decls', env) -> begin
(((FStar_List.append decls decls')), (env))
end))
end)) (([]), (env)))))


let encode_top_level_let : env_t  ->  (Prims.bool * FStar_Syntax_Syntax.letbinding Prims.list)  ->  FStar_Syntax_Syntax.qualifier Prims.list  ->  (FStar_SMTEncoding_Term.decl Prims.list * env_t) = (fun env _86_2204 quals -> (match (_86_2204) with
| (is_rec, bindings) -> begin
(

let eta_expand = (fun binders formals body t -> (

let nbinders = (FStar_List.length binders)
in (

let _86_2214 = (FStar_Util.first_N nbinders formals)
in (match (_86_2214) with
| (formals, extra_formals) -> begin
(

let subst = (FStar_List.map2 (fun _86_2218 _86_2222 -> (match (((_86_2218), (_86_2222))) with
| ((formal, _86_2217), (binder, _86_2221)) -> begin
(let _179_1951 = (let _179_1950 = (FStar_Syntax_Syntax.bv_to_name binder)
in ((formal), (_179_1950)))
in FStar_Syntax_Syntax.NT (_179_1951))
end)) formals binders)
in (

let extra_formals = (let _179_1955 = (FStar_All.pipe_right extra_formals (FStar_List.map (fun _86_2226 -> (match (_86_2226) with
| (x, i) -> begin
(let _179_1954 = (

let _86_2227 = x
in (let _179_1953 = (FStar_Syntax_Subst.subst subst x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _86_2227.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _86_2227.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _179_1953}))
in ((_179_1954), (i)))
end))))
in (FStar_All.pipe_right _179_1955 FStar_Syntax_Util.name_binders))
in (

let body = (let _179_1962 = (FStar_Syntax_Subst.compress body)
in (let _179_1961 = (let _179_1956 = (FStar_Syntax_Util.args_of_binders extra_formals)
in (FStar_All.pipe_left Prims.snd _179_1956))
in (let _179_1960 = (let _179_1959 = (let _179_1958 = (FStar_Syntax_Subst.subst subst t)
in _179_1958.FStar_Syntax_Syntax.n)
in (FStar_All.pipe_left (fun _179_1957 -> Some (_179_1957)) _179_1959))
in (FStar_Syntax_Syntax.extend_app_n _179_1962 _179_1961 _179_1960 body.FStar_Syntax_Syntax.pos))))
in (((FStar_List.append binders extra_formals)), (body)))))
end))))
in (

let destruct_bound_function = (fun flid t_norm e -> (

let rec aux = (fun norm t_norm -> (match ((let _179_1973 = (FStar_Syntax_Util.unascribe e)
in _179_1973.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_abs (binders, body, lopt) -> begin
(

let _86_2246 = (FStar_Syntax_Subst.open_term' binders body)
in (match (_86_2246) with
| (binders, body, opening) -> begin
(match ((let _179_1974 = (FStar_Syntax_Subst.compress t_norm)
in _179_1974.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (formals, c) -> begin
(

let _86_2253 = (FStar_Syntax_Subst.open_comp formals c)
in (match (_86_2253) with
| (formals, c) -> begin
(

let nformals = (FStar_List.length formals)
in (

let nbinders = (FStar_List.length binders)
in (

let tres = (FStar_Syntax_Util.comp_result c)
in if ((nformals < nbinders) && (FStar_Syntax_Util.is_total_comp c)) then begin
(

let lopt = (subst_lcomp_opt opening lopt)
in (

let _86_2260 = (FStar_Util.first_N nformals binders)
in (match (_86_2260) with
| (bs0, rest) -> begin
(

let c = (

let subst = (FStar_List.map2 (fun _86_2264 _86_2268 -> (match (((_86_2264), (_86_2268))) with
| ((b, _86_2263), (x, _86_2267)) -> begin
(let _179_1978 = (let _179_1977 = (FStar_Syntax_Syntax.bv_to_name x)
in ((b), (_179_1977)))
in FStar_Syntax_Syntax.NT (_179_1978))
end)) bs0 formals)
in (FStar_Syntax_Subst.subst_comp subst c))
in (

let body = (FStar_Syntax_Util.abs rest body lopt)
in ((bs0), (body), (bs0), ((FStar_Syntax_Util.comp_result c)))))
end)))
end else begin
if (nformals > nbinders) then begin
(

let _86_2274 = (eta_expand binders formals body tres)
in (match (_86_2274) with
| (binders, body) -> begin
((binders), (body), (formals), (tres))
end))
end else begin
((binders), (body), (formals), (tres))
end
end)))
end))
end
| FStar_Syntax_Syntax.Tm_refine (x, _86_2277) -> begin
(aux norm x.FStar_Syntax_Syntax.sort)
end
| _86_2281 when (not (norm)) -> begin
(

let t_norm = (FStar_TypeChecker_Normalize.normalize ((FStar_TypeChecker_Normalize.AllowUnboundUniverses)::(FStar_TypeChecker_Normalize.Beta)::(FStar_TypeChecker_Normalize.WHNF)::(FStar_TypeChecker_Normalize.UnfoldUntil (FStar_Syntax_Syntax.Delta_constant))::(FStar_TypeChecker_Normalize.EraseUniverses)::[]) env.tcenv t_norm)
in (aux true t_norm))
end
| _86_2284 -> begin
(let _179_1981 = (let _179_1980 = (FStar_Syntax_Print.term_to_string e)
in (let _179_1979 = (FStar_Syntax_Print.term_to_string t_norm)
in (FStar_Util.format3 "Impossible! let-bound lambda %s = %s has a type that\'s not a function: %s\n" flid.FStar_Ident.str _179_1980 _179_1979)))
in (FStar_All.failwith _179_1981))
end)
end))
end
| _86_2286 -> begin
(match ((let _179_1982 = (FStar_Syntax_Subst.compress t_norm)
in _179_1982.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (formals, c) -> begin
(

let _86_2293 = (FStar_Syntax_Subst.open_comp formals c)
in (match (_86_2293) with
| (formals, c) -> begin
(

let tres = (FStar_Syntax_Util.comp_result c)
in (

let _86_2297 = (eta_expand [] formals e tres)
in (match (_86_2297) with
| (binders, body) -> begin
((binders), (body), (formals), (tres))
end)))
end))
end
| _86_2299 -> begin
(([]), (e), ([]), (t_norm))
end)
end))
in (aux false t_norm)))
in try
(match (()) with
| () -> begin
if (FStar_All.pipe_right bindings (FStar_Util.for_all (fun lb -> (FStar_Syntax_Util.is_lemma lb.FStar_Syntax_Syntax.lbtyp)))) then begin
(encode_top_level_vals env bindings quals)
end else begin
(

let _86_2327 = (FStar_All.pipe_right bindings (FStar_List.fold_left (fun _86_2314 lb -> (match (_86_2314) with
| (toks, typs, decls, env) -> begin
(

let _86_2316 = if (FStar_Syntax_Util.is_lemma lb.FStar_Syntax_Syntax.lbtyp) then begin
(Prims.raise Let_rec_unencodeable)
end else begin
()
end
in (

let t_norm = (whnf env lb.FStar_Syntax_Syntax.lbtyp)
in (

let _86_2322 = (let _179_1987 = (FStar_Util.right lb.FStar_Syntax_Syntax.lbname)
in (declare_top_level_let env _179_1987 lb.FStar_Syntax_Syntax.lbtyp t_norm))
in (match (_86_2322) with
| (tok, decl, env) -> begin
(let _179_1990 = (let _179_1989 = (let _179_1988 = (FStar_Util.right lb.FStar_Syntax_Syntax.lbname)
in ((_179_1988), (tok)))
in (_179_1989)::toks)
in ((_179_1990), ((t_norm)::typs), ((decl)::decls), (env)))
end))))
end)) (([]), ([]), ([]), (env))))
in (match (_86_2327) with
| (toks, typs, decls, env) -> begin
(

let toks = (FStar_List.rev toks)
in (

let decls = (FStar_All.pipe_right (FStar_List.rev decls) FStar_List.flatten)
in (

let typs = (FStar_List.rev typs)
in if ((FStar_All.pipe_right quals (FStar_Util.for_some (fun _86_15 -> (match (_86_15) with
| FStar_Syntax_Syntax.HasMaskedEffect -> begin
true
end
| _86_2334 -> begin
false
end)))) || (FStar_All.pipe_right typs (FStar_Util.for_some (fun t -> (let _179_1993 = (FStar_Syntax_Util.is_pure_or_ghost_function t)
in (FStar_All.pipe_left Prims.op_Negation _179_1993)))))) then begin
((decls), (env))
end else begin
if (not (is_rec)) then begin
(match (((bindings), (typs), (toks))) with
| (({FStar_Syntax_Syntax.lbname = _86_2344; FStar_Syntax_Syntax.lbunivs = _86_2342; FStar_Syntax_Syntax.lbtyp = _86_2340; FStar_Syntax_Syntax.lbeff = _86_2338; FStar_Syntax_Syntax.lbdef = e})::[], (t_norm)::[], ((flid_fv, (f, ftok)))::[]) -> begin
(

let e = (FStar_Syntax_Subst.compress e)
in (

let flid = flid_fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v
in (

let _86_2364 = (destruct_bound_function flid t_norm e)
in (match (_86_2364) with
| (binders, body, _86_2361, _86_2363) -> begin
(

let _86_2371 = (encode_binders None binders env)
in (match (_86_2371) with
| (vars, guards, env', binder_decls, _86_2370) -> begin
(

let app = (match (vars) with
| [] -> begin
(FStar_SMTEncoding_Term.mkFreeV ((f), (FStar_SMTEncoding_Term.Term_sort)))
end
| _86_2374 -> begin
(let _179_1995 = (let _179_1994 = (FStar_List.map FStar_SMTEncoding_Term.mkFreeV vars)
in ((f), (_179_1994)))
in (FStar_SMTEncoding_Term.mkApp _179_1995))
end)
in (

let _86_2380 = if (FStar_All.pipe_right quals (FStar_List.contains FStar_Syntax_Syntax.Logic)) then begin
(let _179_1997 = (FStar_SMTEncoding_Term.mk_Valid app)
in (let _179_1996 = (encode_formula body env')
in ((_179_1997), (_179_1996))))
end else begin
(let _179_1998 = (encode_term body env')
in ((app), (_179_1998)))
end
in (match (_86_2380) with
| (app, (body, decls2)) -> begin
(

let eqn = (let _179_2004 = (let _179_2003 = (let _179_2000 = (let _179_1999 = (FStar_SMTEncoding_Term.mkEq ((app), (body)))
in ((((app)::[])::[]), (vars), (_179_1999)))
in (FStar_SMTEncoding_Term.mkForall _179_2000))
in (let _179_2002 = (let _179_2001 = (FStar_Util.format1 "Equation for %s" flid.FStar_Ident.str)
in Some (_179_2001))
in ((_179_2003), (_179_2002), (Some ((Prims.strcat "equation_" f))))))
in FStar_SMTEncoding_Term.Assume (_179_2004))
in (let _179_2009 = (let _179_2008 = (let _179_2007 = (let _179_2006 = (let _179_2005 = (primitive_type_axioms env.tcenv flid f app)
in (FStar_List.append ((eqn)::[]) _179_2005))
in (FStar_List.append decls2 _179_2006))
in (FStar_List.append binder_decls _179_2007))
in (FStar_List.append decls _179_2008))
in ((_179_2009), (env))))
end)))
end))
end))))
end
| _86_2383 -> begin
(FStar_All.failwith "Impossible")
end)
end else begin
(

let fuel = (let _179_2010 = (varops.fresh "fuel")
in ((_179_2010), (FStar_SMTEncoding_Term.Fuel_sort)))
in (

let fuel_tm = (FStar_SMTEncoding_Term.mkFreeV fuel)
in (

let env0 = env
in (

let _86_2401 = (FStar_All.pipe_right toks (FStar_List.fold_left (fun _86_2389 _86_2394 -> (match (((_86_2389), (_86_2394))) with
| ((gtoks, env), (flid_fv, (f, ftok))) -> begin
(

let flid = flid_fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v
in (

let g = (let _179_2013 = (FStar_Ident.lid_add_suffix flid "fuel_instrumented")
in (varops.new_fvar _179_2013))
in (

let gtok = (let _179_2014 = (FStar_Ident.lid_add_suffix flid "fuel_instrumented_token")
in (varops.new_fvar _179_2014))
in (

let env = (let _179_2017 = (let _179_2016 = (FStar_SMTEncoding_Term.mkApp ((g), ((fuel_tm)::[])))
in (FStar_All.pipe_left (fun _179_2015 -> Some (_179_2015)) _179_2016))
in (push_free_var env flid gtok _179_2017))
in (((((flid), (f), (ftok), (g), (gtok)))::gtoks), (env))))))
end)) (([]), (env))))
in (match (_86_2401) with
| (gtoks, env) -> begin
(

let gtoks = (FStar_List.rev gtoks)
in (

let encode_one_binding = (fun env0 _86_2410 t_norm _86_2421 -> (match (((_86_2410), (_86_2421))) with
| ((flid, f, ftok, g, gtok), {FStar_Syntax_Syntax.lbname = _86_2420; FStar_Syntax_Syntax.lbunivs = _86_2418; FStar_Syntax_Syntax.lbtyp = _86_2416; FStar_Syntax_Syntax.lbeff = _86_2414; FStar_Syntax_Syntax.lbdef = e}) -> begin
(

let _86_2426 = (destruct_bound_function flid t_norm e)
in (match (_86_2426) with
| (binders, body, formals, tres) -> begin
(

let _86_2433 = (encode_binders None binders env)
in (match (_86_2433) with
| (vars, guards, env', binder_decls, _86_2432) -> begin
(

let decl_g = (let _179_2028 = (let _179_2027 = (let _179_2026 = (FStar_List.map Prims.snd vars)
in (FStar_SMTEncoding_Term.Fuel_sort)::_179_2026)
in ((g), (_179_2027), (FStar_SMTEncoding_Term.Term_sort), (Some ("Fuel-instrumented function name"))))
in FStar_SMTEncoding_Term.DeclFun (_179_2028))
in (

let env0 = (push_zfuel_name env0 flid g)
in (

let decl_g_tok = FStar_SMTEncoding_Term.DeclFun (((gtok), ([]), (FStar_SMTEncoding_Term.Term_sort), (Some ("Token for fuel-instrumented partial applications"))))
in (

let vars_tm = (FStar_List.map FStar_SMTEncoding_Term.mkFreeV vars)
in (

let app = (FStar_SMTEncoding_Term.mkApp ((f), (vars_tm)))
in (

let gsapp = (let _179_2031 = (let _179_2030 = (let _179_2029 = (FStar_SMTEncoding_Term.mkApp (("SFuel"), ((fuel_tm)::[])))
in (_179_2029)::vars_tm)
in ((g), (_179_2030)))
in (FStar_SMTEncoding_Term.mkApp _179_2031))
in (

let gmax = (let _179_2034 = (let _179_2033 = (let _179_2032 = (FStar_SMTEncoding_Term.mkApp (("MaxFuel"), ([])))
in (_179_2032)::vars_tm)
in ((g), (_179_2033)))
in (FStar_SMTEncoding_Term.mkApp _179_2034))
in (

let _86_2443 = (encode_term body env')
in (match (_86_2443) with
| (body_tm, decls2) -> begin
(

let eqn_g = (let _179_2040 = (let _179_2039 = (let _179_2036 = (let _179_2035 = (FStar_SMTEncoding_Term.mkEq ((gsapp), (body_tm)))
in ((((gsapp)::[])::[]), (Some ((Prims.parse_int "0"))), ((fuel)::vars), (_179_2035)))
in (FStar_SMTEncoding_Term.mkForall' _179_2036))
in (let _179_2038 = (let _179_2037 = (FStar_Util.format1 "Equation for fuel-instrumented recursive function: %s" flid.FStar_Ident.str)
in Some (_179_2037))
in ((_179_2039), (_179_2038), (Some ((Prims.strcat "equation_with_fuel_" g))))))
in FStar_SMTEncoding_Term.Assume (_179_2040))
in (

let eqn_f = (let _179_2044 = (let _179_2043 = (let _179_2042 = (let _179_2041 = (FStar_SMTEncoding_Term.mkEq ((app), (gmax)))
in ((((app)::[])::[]), (vars), (_179_2041)))
in (FStar_SMTEncoding_Term.mkForall _179_2042))
in ((_179_2043), (Some ("Correspondence of recursive function to instrumented version")), (Some ((Prims.strcat "fuel_correspondence_" g)))))
in FStar_SMTEncoding_Term.Assume (_179_2044))
in (

let eqn_g' = (let _179_2053 = (let _179_2052 = (let _179_2051 = (let _179_2050 = (let _179_2049 = (let _179_2048 = (let _179_2047 = (let _179_2046 = (let _179_2045 = (FStar_SMTEncoding_Term.n_fuel (Prims.parse_int "0"))
in (_179_2045)::vars_tm)
in ((g), (_179_2046)))
in (FStar_SMTEncoding_Term.mkApp _179_2047))
in ((gsapp), (_179_2048)))
in (FStar_SMTEncoding_Term.mkEq _179_2049))
in ((((gsapp)::[])::[]), ((fuel)::vars), (_179_2050)))
in (FStar_SMTEncoding_Term.mkForall _179_2051))
in ((_179_2052), (Some ("Fuel irrelevance")), (Some ((Prims.strcat "fuel_irrelevance_" g)))))
in FStar_SMTEncoding_Term.Assume (_179_2053))
in (

let _86_2466 = (

let _86_2453 = (encode_binders None formals env0)
in (match (_86_2453) with
| (vars, v_guards, env, binder_decls, _86_2452) -> begin
(

let vars_tm = (FStar_List.map FStar_SMTEncoding_Term.mkFreeV vars)
in (

let gapp = (FStar_SMTEncoding_Term.mkApp ((g), ((fuel_tm)::vars_tm)))
in (

let tok_corr = (

let tok_app = (let _179_2054 = (FStar_SMTEncoding_Term.mkFreeV ((gtok), (FStar_SMTEncoding_Term.Term_sort)))
in (mk_Apply _179_2054 ((fuel)::vars)))
in (let _179_2058 = (let _179_2057 = (let _179_2056 = (let _179_2055 = (FStar_SMTEncoding_Term.mkEq ((tok_app), (gapp)))
in ((((tok_app)::[])::[]), ((fuel)::vars), (_179_2055)))
in (FStar_SMTEncoding_Term.mkForall _179_2056))
in ((_179_2057), (Some ("Fuel token correspondence")), (Some ((Prims.strcat "fuel_token_correspondence_" gtok)))))
in FStar_SMTEncoding_Term.Assume (_179_2058)))
in (

let _86_2463 = (

let _86_2460 = (encode_term_pred None tres env gapp)
in (match (_86_2460) with
| (g_typing, d3) -> begin
(let _179_2066 = (let _179_2065 = (let _179_2064 = (let _179_2063 = (let _179_2062 = (let _179_2061 = (let _179_2060 = (let _179_2059 = (FStar_SMTEncoding_Term.mk_and_l v_guards)
in ((_179_2059), (g_typing)))
in (FStar_SMTEncoding_Term.mkImp _179_2060))
in ((((gapp)::[])::[]), ((fuel)::vars), (_179_2061)))
in (FStar_SMTEncoding_Term.mkForall _179_2062))
in ((_179_2063), (Some ("Typing correspondence of token to term")), (Some ((Prims.strcat "token_correspondence_" g)))))
in FStar_SMTEncoding_Term.Assume (_179_2064))
in (_179_2065)::[])
in ((d3), (_179_2066)))
end))
in (match (_86_2463) with
| (aux_decls, typing_corr) -> begin
(((FStar_List.append binder_decls aux_decls)), ((FStar_List.append typing_corr ((tok_corr)::[]))))
end)))))
end))
in (match (_86_2466) with
| (aux_decls, g_typing) -> begin
(((FStar_List.append binder_decls (FStar_List.append decls2 (FStar_List.append aux_decls ((decl_g)::(decl_g_tok)::[]))))), ((FStar_List.append ((eqn_g)::(eqn_g')::(eqn_f)::[]) g_typing)), (env0))
end)))))
end)))))))))
end))
end))
end))
in (

let _86_2482 = (let _179_2069 = (FStar_List.zip3 gtoks typs bindings)
in (FStar_List.fold_left (fun _86_2470 _86_2474 -> (match (((_86_2470), (_86_2474))) with
| ((decls, eqns, env0), (gtok, ty, bs)) -> begin
(

let _86_2478 = (encode_one_binding env0 gtok ty bs)
in (match (_86_2478) with
| (decls', eqns', env0) -> begin
(((decls')::decls), ((FStar_List.append eqns' eqns)), (env0))
end))
end)) (((decls)::[]), ([]), (env0)) _179_2069))
in (match (_86_2482) with
| (decls, eqns, env0) -> begin
(

let _86_2491 = (let _179_2071 = (FStar_All.pipe_right decls FStar_List.flatten)
in (FStar_All.pipe_right _179_2071 (FStar_List.partition (fun _86_16 -> (match (_86_16) with
| FStar_SMTEncoding_Term.DeclFun (_86_2485) -> begin
true
end
| _86_2488 -> begin
false
end)))))
in (match (_86_2491) with
| (prefix_decls, rest) -> begin
(

let eqns = (FStar_List.rev eqns)
in (((FStar_List.append prefix_decls (FStar_List.append rest eqns))), (env0)))
end))
end))))
end)))))
end
end)))
end))
end
end)
with
| Let_rec_unencodeable -> begin
(

let msg = (let _179_2074 = (FStar_All.pipe_right bindings (FStar_List.map (fun lb -> (FStar_Syntax_Print.lbname_to_string lb.FStar_Syntax_Syntax.lbname))))
in (FStar_All.pipe_right _179_2074 (FStar_String.concat " and ")))
in (

let decl = FStar_SMTEncoding_Term.Caption ((Prims.strcat "let rec unencodeable: Skipping: " msg))
in (((decl)::[]), (env))))
end))
end))


let rec encode_sigelt : env_t  ->  FStar_Syntax_Syntax.sigelt  ->  (FStar_SMTEncoding_Term.decls_t * env_t) = (fun env se -> (

let _86_2495 = if (FStar_All.pipe_left (FStar_TypeChecker_Env.debug env.tcenv) (FStar_Options.Other ("SMTEncoding"))) then begin
(let _179_2083 = (FStar_Syntax_Print.sigelt_to_string se)
in (FStar_All.pipe_left (FStar_Util.print1 ">>>>Encoding [%s]\n") _179_2083))
end else begin
()
end
in (

let nm = (match ((FStar_Syntax_Util.lid_of_sigelt se)) with
| None -> begin
""
end
| Some (l) -> begin
l.FStar_Ident.str
end)
in (

let _86_2503 = (encode_sigelt' env se)
in (match (_86_2503) with
| (g, e) -> begin
(match (g) with
| [] -> begin
(let _179_2086 = (let _179_2085 = (let _179_2084 = (FStar_Util.format1 "<Skipped %s/>" nm)
in FStar_SMTEncoding_Term.Caption (_179_2084))
in (_179_2085)::[])
in ((_179_2086), (e)))
end
| _86_2506 -> begin
(let _179_2093 = (let _179_2092 = (let _179_2088 = (let _179_2087 = (FStar_Util.format1 "<Start encoding %s>" nm)
in FStar_SMTEncoding_Term.Caption (_179_2087))
in (_179_2088)::g)
in (let _179_2091 = (let _179_2090 = (let _179_2089 = (FStar_Util.format1 "</end encoding %s>" nm)
in FStar_SMTEncoding_Term.Caption (_179_2089))
in (_179_2090)::[])
in (FStar_List.append _179_2092 _179_2091)))
in ((_179_2093), (e)))
end)
end)))))
and encode_sigelt' : env_t  ->  FStar_Syntax_Syntax.sigelt  ->  (FStar_SMTEncoding_Term.decls_t * env_t) = (fun env se -> (

let should_skip = (fun l -> false)
in (match (se) with
| FStar_Syntax_Syntax.Sig_new_effect_for_free (_86_2512) -> begin
(FStar_All.failwith "impossible -- removed by tc.fs")
end
| (FStar_Syntax_Syntax.Sig_pragma (_)) | (FStar_Syntax_Syntax.Sig_main (_)) | (FStar_Syntax_Syntax.Sig_effect_abbrev (_)) | (FStar_Syntax_Syntax.Sig_sub_effect (_)) -> begin
(([]), (env))
end
| FStar_Syntax_Syntax.Sig_new_effect (ed, _86_2528) -> begin
if (let _179_2098 = (FStar_All.pipe_right ed.FStar_Syntax_Syntax.qualifiers (FStar_List.contains FStar_Syntax_Syntax.Reifiable))
in (FStar_All.pipe_right _179_2098 Prims.op_Negation)) then begin
(([]), (env))
end else begin
(

let close_effect_params = (fun tm -> (match (ed.FStar_Syntax_Syntax.binders) with
| [] -> begin
tm
end
| _86_2535 -> begin
(let _179_2104 = (let _179_2103 = (let _179_2102 = (FStar_All.pipe_left (fun _179_2101 -> Some (_179_2101)) (FStar_Util.Inr (FStar_Syntax_Const.effect_Tot_lid)))
in ((ed.FStar_Syntax_Syntax.binders), (tm), (_179_2102)))
in FStar_Syntax_Syntax.Tm_abs (_179_2103))
in (FStar_Syntax_Syntax.mk _179_2104 None tm.FStar_Syntax_Syntax.pos))
end))
in (

let encode_action = (fun env a -> (

let _86_2542 = (new_term_constant_and_tok_from_lid env a.FStar_Syntax_Syntax.action_name)
in (match (_86_2542) with
| (aname, atok, env) -> begin
(

let _86_2546 = (FStar_Syntax_Util.arrow_formals_comp a.FStar_Syntax_Syntax.action_typ)
in (match (_86_2546) with
| (formals, _86_2545) -> begin
(

let _86_2549 = (let _179_2109 = (close_effect_params a.FStar_Syntax_Syntax.action_defn)
in (encode_term _179_2109 env))
in (match (_86_2549) with
| (tm, decls) -> begin
(

let a_decls = (let _179_2113 = (let _179_2112 = (let _179_2111 = (FStar_All.pipe_right formals (FStar_List.map (fun _86_2550 -> FStar_SMTEncoding_Term.Term_sort)))
in ((aname), (_179_2111), (FStar_SMTEncoding_Term.Term_sort), (Some ("Action"))))
in FStar_SMTEncoding_Term.DeclFun (_179_2112))
in (_179_2113)::(FStar_SMTEncoding_Term.DeclFun (((atok), ([]), (FStar_SMTEncoding_Term.Term_sort), (Some ("Action token")))))::[])
in (

let _86_2564 = (let _179_2115 = (FStar_All.pipe_right formals (FStar_List.map (fun _86_2556 -> (match (_86_2556) with
| (bv, _86_2555) -> begin
(

let _86_2561 = (gen_term_var env bv)
in (match (_86_2561) with
| (xxsym, xx, _86_2560) -> begin
((((xxsym), (FStar_SMTEncoding_Term.Term_sort))), (xx))
end))
end))))
in (FStar_All.pipe_right _179_2115 FStar_List.split))
in (match (_86_2564) with
| (xs_sorts, xs) -> begin
(

let app = (let _179_2119 = (let _179_2118 = (let _179_2117 = (let _179_2116 = (FStar_SMTEncoding_Term.mk (FStar_SMTEncoding_Term.App (((FStar_SMTEncoding_Term.Var (aname)), (xs)))))
in (_179_2116)::[])
in ((FStar_SMTEncoding_Term.Var ("Reify")), (_179_2117)))
in FStar_SMTEncoding_Term.App (_179_2118))
in (FStar_All.pipe_right _179_2119 FStar_SMTEncoding_Term.mk))
in (

let a_eq = (let _179_2125 = (let _179_2124 = (let _179_2123 = (let _179_2122 = (let _179_2121 = (let _179_2120 = (mk_Apply tm xs_sorts)
in ((app), (_179_2120)))
in (FStar_SMTEncoding_Term.mkEq _179_2121))
in ((((app)::[])::[]), (xs_sorts), (_179_2122)))
in (FStar_SMTEncoding_Term.mkForall _179_2123))
in ((_179_2124), (Some ("Action equality")), (Some ((Prims.strcat aname "_equality")))))
in FStar_SMTEncoding_Term.Assume (_179_2125))
in (

let tok_correspondence = (

let tok_term = (FStar_SMTEncoding_Term.mkFreeV ((atok), (FStar_SMTEncoding_Term.Term_sort)))
in (

let tok_app = (mk_Apply tok_term xs_sorts)
in (let _179_2129 = (let _179_2128 = (let _179_2127 = (let _179_2126 = (FStar_SMTEncoding_Term.mkEq ((tok_app), (app)))
in ((((tok_app)::[])::[]), (xs_sorts), (_179_2126)))
in (FStar_SMTEncoding_Term.mkForall _179_2127))
in ((_179_2128), (Some ("Action token correspondence")), (Some ((Prims.strcat aname "_token_correspondence")))))
in FStar_SMTEncoding_Term.Assume (_179_2129))))
in ((env), ((FStar_List.append decls (FStar_List.append a_decls ((a_eq)::(tok_correspondence)::[]))))))))
end)))
end))
end))
end)))
in (

let _86_2572 = (FStar_Util.fold_map encode_action env ed.FStar_Syntax_Syntax.actions)
in (match (_86_2572) with
| (env, decls2) -> begin
(((FStar_List.flatten decls2)), (env))
end))))
end
end
| FStar_Syntax_Syntax.Sig_declare_typ (lid, _86_2575, _86_2577, _86_2579, _86_2581) when (FStar_Ident.lid_equals lid FStar_Syntax_Const.precedes_lid) -> begin
(

let _86_2587 = (new_term_constant_and_tok_from_lid env lid)
in (match (_86_2587) with
| (tname, ttok, env) -> begin
(([]), (env))
end))
end
| FStar_Syntax_Syntax.Sig_declare_typ (lid, _86_2590, t, quals, _86_2594) -> begin
(

let will_encode_definition = (not ((FStar_All.pipe_right quals (FStar_Util.for_some (fun _86_17 -> (match (_86_17) with
| (FStar_Syntax_Syntax.Assumption) | (FStar_Syntax_Syntax.Projector (_)) | (FStar_Syntax_Syntax.Discriminator (_)) | (FStar_Syntax_Syntax.Irreducible) -> begin
true
end
| _86_2607 -> begin
false
end))))))
in if will_encode_definition then begin
(([]), (env))
end else begin
(

let fv = (FStar_Syntax_Syntax.lid_as_fv lid FStar_Syntax_Syntax.Delta_constant None)
in (

let _86_2612 = (encode_top_level_val env fv t quals)
in (match (_86_2612) with
| (decls, env) -> begin
(

let tname = lid.FStar_Ident.str
in (

let tsym = (FStar_SMTEncoding_Term.mkFreeV ((tname), (FStar_SMTEncoding_Term.Term_sort)))
in (let _179_2132 = (let _179_2131 = (primitive_type_axioms env.tcenv lid tname tsym)
in (FStar_List.append decls _179_2131))
in ((_179_2132), (env)))))
end)))
end)
end
| FStar_Syntax_Syntax.Sig_assume (l, f, _86_2618, _86_2620) -> begin
(

let _86_2625 = (encode_formula f env)
in (match (_86_2625) with
| (f, decls) -> begin
(

let g = (let _179_2139 = (let _179_2138 = (let _179_2137 = (let _179_2134 = (let _179_2133 = (FStar_Syntax_Print.lid_to_string l)
in (FStar_Util.format1 "Assumption: %s" _179_2133))
in Some (_179_2134))
in (let _179_2136 = (let _179_2135 = (varops.mk_unique (Prims.strcat "assumption_" l.FStar_Ident.str))
in Some (_179_2135))
in ((f), (_179_2137), (_179_2136))))
in FStar_SMTEncoding_Term.Assume (_179_2138))
in (_179_2139)::[])
in (((FStar_List.append decls g)), (env)))
end))
end
| FStar_Syntax_Syntax.Sig_let (lbs, r, _86_2630, quals) when (FStar_All.pipe_right quals (FStar_List.contains FStar_Syntax_Syntax.Irreducible)) -> begin
(

let _86_2643 = (FStar_Util.fold_map (fun env lb -> (

let lid = (let _179_2143 = (let _179_2142 = (FStar_Util.right lb.FStar_Syntax_Syntax.lbname)
in _179_2142.FStar_Syntax_Syntax.fv_name)
in _179_2143.FStar_Syntax_Syntax.v)
in if (let _179_2144 = (FStar_TypeChecker_Env.try_lookup_val_decl env.tcenv lid)
in (FStar_All.pipe_left FStar_Option.isNone _179_2144)) then begin
(

let val_decl = FStar_Syntax_Syntax.Sig_declare_typ (((lid), (lb.FStar_Syntax_Syntax.lbunivs), (lb.FStar_Syntax_Syntax.lbtyp), (quals), (r)))
in (

let _86_2640 = (encode_sigelt' env val_decl)
in (match (_86_2640) with
| (decls, env) -> begin
((env), (decls))
end)))
end else begin
((env), ([]))
end)) env (Prims.snd lbs))
in (match (_86_2643) with
| (env, decls) -> begin
(((FStar_List.flatten decls)), (env))
end))
end
| FStar_Syntax_Syntax.Sig_let ((_86_2645, ({FStar_Syntax_Syntax.lbname = FStar_Util.Inr (b2t); FStar_Syntax_Syntax.lbunivs = _86_2653; FStar_Syntax_Syntax.lbtyp = _86_2651; FStar_Syntax_Syntax.lbeff = _86_2649; FStar_Syntax_Syntax.lbdef = _86_2647})::[]), _86_2660, _86_2662, _86_2664) when (FStar_Syntax_Syntax.fv_eq_lid b2t FStar_Syntax_Const.b2t_lid) -> begin
(

let _86_2670 = (new_term_constant_and_tok_from_lid env b2t.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)
in (match (_86_2670) with
| (tname, ttok, env) -> begin
(

let xx = (("x"), (FStar_SMTEncoding_Term.Term_sort))
in (

let x = (FStar_SMTEncoding_Term.mkFreeV xx)
in (

let valid_b2t_x = (let _179_2147 = (let _179_2146 = (let _179_2145 = (FStar_SMTEncoding_Term.mkApp (("Prims.b2t"), ((x)::[])))
in (_179_2145)::[])
in (("Valid"), (_179_2146)))
in (FStar_SMTEncoding_Term.mkApp _179_2147))
in (

let decls = (let _179_2155 = (let _179_2154 = (let _179_2153 = (let _179_2152 = (let _179_2151 = (let _179_2150 = (let _179_2149 = (let _179_2148 = (FStar_SMTEncoding_Term.mkApp (("BoxBool_proj_0"), ((x)::[])))
in ((valid_b2t_x), (_179_2148)))
in (FStar_SMTEncoding_Term.mkEq _179_2149))
in ((((valid_b2t_x)::[])::[]), ((xx)::[]), (_179_2150)))
in (FStar_SMTEncoding_Term.mkForall _179_2151))
in ((_179_2152), (Some ("b2t def")), (Some ("b2t_def"))))
in FStar_SMTEncoding_Term.Assume (_179_2153))
in (_179_2154)::[])
in (FStar_SMTEncoding_Term.DeclFun (((tname), ((FStar_SMTEncoding_Term.Term_sort)::[]), (FStar_SMTEncoding_Term.Term_sort), (None))))::_179_2155)
in ((decls), (env))))))
end))
end
| FStar_Syntax_Syntax.Sig_let (_86_2676, _86_2678, _86_2680, quals) when (FStar_All.pipe_right quals (FStar_Util.for_some (fun _86_18 -> (match (_86_18) with
| FStar_Syntax_Syntax.Discriminator (_86_2686) -> begin
true
end
| _86_2689 -> begin
false
end)))) -> begin
(([]), (env))
end
| FStar_Syntax_Syntax.Sig_let (_86_2691, _86_2693, lids, quals) when ((FStar_All.pipe_right lids (FStar_Util.for_some (fun l -> ((let _179_2158 = (FStar_List.hd l.FStar_Ident.ns)
in _179_2158.FStar_Ident.idText) = "Prims")))) && (FStar_All.pipe_right quals (FStar_Util.for_some (fun _86_19 -> (match (_86_19) with
| FStar_Syntax_Syntax.Inline -> begin
true
end
| _86_2702 -> begin
false
end))))) -> begin
(([]), (env))
end
| FStar_Syntax_Syntax.Sig_let ((false, (lb)::[]), _86_2708, _86_2710, quals) when (FStar_All.pipe_right quals (FStar_Util.for_some (fun _86_20 -> (match (_86_20) with
| FStar_Syntax_Syntax.Projector (_86_2716) -> begin
true
end
| _86_2719 -> begin
false
end)))) -> begin
(

let fv = (FStar_Util.right lb.FStar_Syntax_Syntax.lbname)
in (

let l = fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v
in (match ((try_lookup_free_var env l)) with
| Some (_86_2723) -> begin
(([]), (env))
end
| None -> begin
(

let se = FStar_Syntax_Syntax.Sig_declare_typ (((l), (lb.FStar_Syntax_Syntax.lbunivs), (lb.FStar_Syntax_Syntax.lbtyp), (quals), ((FStar_Ident.range_of_lid l))))
in (encode_sigelt env se))
end)))
end
| FStar_Syntax_Syntax.Sig_let ((false, (lb)::[]), _86_2732, _86_2734, quals) when (FStar_All.pipe_right quals (FStar_List.contains FStar_Syntax_Syntax.Reifiable)) -> begin
(match ((let _179_2161 = (FStar_Syntax_Subst.compress lb.FStar_Syntax_Syntax.lbdef)
in _179_2161.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_abs (bs, body, _86_2741) -> begin
(

let body = (FStar_Syntax_Util.mk_reify body)
in (

let tm = (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_abs (((bs), (body), (None)))) None lb.FStar_Syntax_Syntax.lbdef.FStar_Syntax_Syntax.pos)
in (

let tm' = (FStar_TypeChecker_Normalize.normalize ((FStar_TypeChecker_Normalize.Beta)::(FStar_TypeChecker_Normalize.Reify)::(FStar_TypeChecker_Normalize.Inline)::(FStar_TypeChecker_Normalize.EraseUniverses)::(FStar_TypeChecker_Normalize.AllowUnboundUniverses)::[]) env.tcenv tm)
in (

let lb_typ = (

let _86_2749 = (FStar_Syntax_Util.arrow_formals_comp lb.FStar_Syntax_Syntax.lbtyp)
in (match (_86_2749) with
| (formals, comp) -> begin
(

let reified_typ = (FStar_TypeChecker_Util.reify_comp (

let _86_2750 = env.tcenv
in {FStar_TypeChecker_Env.solver = _86_2750.FStar_TypeChecker_Env.solver; FStar_TypeChecker_Env.range = _86_2750.FStar_TypeChecker_Env.range; FStar_TypeChecker_Env.curmodule = _86_2750.FStar_TypeChecker_Env.curmodule; FStar_TypeChecker_Env.gamma = _86_2750.FStar_TypeChecker_Env.gamma; FStar_TypeChecker_Env.gamma_cache = _86_2750.FStar_TypeChecker_Env.gamma_cache; FStar_TypeChecker_Env.modules = _86_2750.FStar_TypeChecker_Env.modules; FStar_TypeChecker_Env.expected_typ = _86_2750.FStar_TypeChecker_Env.expected_typ; FStar_TypeChecker_Env.sigtab = _86_2750.FStar_TypeChecker_Env.sigtab; FStar_TypeChecker_Env.is_pattern = _86_2750.FStar_TypeChecker_Env.is_pattern; FStar_TypeChecker_Env.instantiate_imp = _86_2750.FStar_TypeChecker_Env.instantiate_imp; FStar_TypeChecker_Env.effects = _86_2750.FStar_TypeChecker_Env.effects; FStar_TypeChecker_Env.generalize = _86_2750.FStar_TypeChecker_Env.generalize; FStar_TypeChecker_Env.letrecs = _86_2750.FStar_TypeChecker_Env.letrecs; FStar_TypeChecker_Env.top_level = _86_2750.FStar_TypeChecker_Env.top_level; FStar_TypeChecker_Env.check_uvars = _86_2750.FStar_TypeChecker_Env.check_uvars; FStar_TypeChecker_Env.use_eq = _86_2750.FStar_TypeChecker_Env.use_eq; FStar_TypeChecker_Env.is_iface = _86_2750.FStar_TypeChecker_Env.is_iface; FStar_TypeChecker_Env.admit = _86_2750.FStar_TypeChecker_Env.admit; FStar_TypeChecker_Env.lax = true; FStar_TypeChecker_Env.type_of = _86_2750.FStar_TypeChecker_Env.type_of; FStar_TypeChecker_Env.universe_of = _86_2750.FStar_TypeChecker_Env.universe_of; FStar_TypeChecker_Env.use_bv_sorts = _86_2750.FStar_TypeChecker_Env.use_bv_sorts; FStar_TypeChecker_Env.qname_and_index = _86_2750.FStar_TypeChecker_Env.qname_and_index}) (FStar_Syntax_Util.lcomp_of_comp comp) FStar_Syntax_Syntax.U_unknown)
in (let _179_2162 = (FStar_Syntax_Syntax.mk_Total reified_typ)
in (FStar_Syntax_Util.arrow formals _179_2162)))
end))
in (

let lb = (

let _86_2754 = lb
in {FStar_Syntax_Syntax.lbname = _86_2754.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = _86_2754.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = lb_typ; FStar_Syntax_Syntax.lbeff = _86_2754.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = tm'})
in (encode_top_level_let env ((false), ((lb)::[])) quals))))))
end
| _86_2758 -> begin
(([]), (env))
end)
end
| FStar_Syntax_Syntax.Sig_let ((is_rec, bindings), _86_2763, _86_2765, quals) -> begin
(encode_top_level_let env ((is_rec), (bindings)) quals)
end
| FStar_Syntax_Syntax.Sig_bundle (ses, _86_2771, _86_2773, _86_2775) -> begin
(

let _86_2780 = (encode_signature env ses)
in (match (_86_2780) with
| (g, env) -> begin
(

let _86_2794 = (FStar_All.pipe_right g (FStar_List.partition (fun _86_21 -> (match (_86_21) with
| FStar_SMTEncoding_Term.Assume (_86_2783, Some ("inversion axiom"), _86_2787) -> begin
false
end
| _86_2791 -> begin
true
end))))
in (match (_86_2794) with
| (g', inversions) -> begin
(

let _86_2803 = (FStar_All.pipe_right g' (FStar_List.partition (fun _86_22 -> (match (_86_22) with
| FStar_SMTEncoding_Term.DeclFun (_86_2797) -> begin
true
end
| _86_2800 -> begin
false
end))))
in (match (_86_2803) with
| (decls, rest) -> begin
(((FStar_List.append decls (FStar_List.append rest inversions))), (env))
end))
end))
end))
end
| FStar_Syntax_Syntax.Sig_inductive_typ (t, _86_2806, tps, k, _86_2810, datas, quals, _86_2814) -> begin
(

let is_logical = (FStar_All.pipe_right quals (FStar_Util.for_some (fun _86_23 -> (match (_86_23) with
| (FStar_Syntax_Syntax.Logic) | (FStar_Syntax_Syntax.Assumption) -> begin
true
end
| _86_2821 -> begin
false
end))))
in (

let constructor_or_logic_type_decl = (fun c -> if is_logical then begin
(

let _86_2833 = c
in (match (_86_2833) with
| (name, args, _86_2828, _86_2830, _86_2832) -> begin
(let _179_2170 = (let _179_2169 = (let _179_2168 = (FStar_All.pipe_right args (FStar_List.map Prims.snd))
in ((name), (_179_2168), (FStar_SMTEncoding_Term.Term_sort), (None)))
in FStar_SMTEncoding_Term.DeclFun (_179_2169))
in (_179_2170)::[])
end))
end else begin
(FStar_SMTEncoding_Term.constructor_to_decl c)
end)
in (

let inversion_axioms = (fun tapp vars -> if (FStar_All.pipe_right datas (FStar_Util.for_some (fun l -> (let _179_2176 = (FStar_TypeChecker_Env.try_lookup_lid env.tcenv l)
in (FStar_All.pipe_right _179_2176 FStar_Option.isNone))))) then begin
[]
end else begin
(

let _86_2840 = (fresh_fvar "x" FStar_SMTEncoding_Term.Term_sort)
in (match (_86_2840) with
| (xxsym, xx) -> begin
(

let _86_2876 = (FStar_All.pipe_right datas (FStar_List.fold_left (fun _86_2843 l -> (match (_86_2843) with
| (out, decls) -> begin
(

let _86_2848 = (FStar_TypeChecker_Env.lookup_datacon env.tcenv l)
in (match (_86_2848) with
| (_86_2846, data_t) -> begin
(

let _86_2851 = (FStar_Syntax_Util.arrow_formals data_t)
in (match (_86_2851) with
| (args, res) -> begin
(

let indices = (match ((let _179_2179 = (FStar_Syntax_Subst.compress res)
in _179_2179.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_app (_86_2853, indices) -> begin
indices
end
| _86_2858 -> begin
[]
end)
in (

let env = (FStar_All.pipe_right args (FStar_List.fold_left (fun env _86_2864 -> (match (_86_2864) with
| (x, _86_2863) -> begin
(let _179_2184 = (let _179_2183 = (let _179_2182 = (mk_term_projector_name l x)
in ((_179_2182), ((xx)::[])))
in (FStar_SMTEncoding_Term.mkApp _179_2183))
in (push_term_var env x _179_2184))
end)) env))
in (

let _86_2868 = (encode_args indices env)
in (match (_86_2868) with
| (indices, decls') -> begin
(

let _86_2869 = if ((FStar_List.length indices) <> (FStar_List.length vars)) then begin
(FStar_All.failwith "Impossible")
end else begin
()
end
in (

let eqs = (let _179_2189 = (FStar_List.map2 (fun v a -> (let _179_2188 = (let _179_2187 = (FStar_SMTEncoding_Term.mkFreeV v)
in ((_179_2187), (a)))
in (FStar_SMTEncoding_Term.mkEq _179_2188))) vars indices)
in (FStar_All.pipe_right _179_2189 FStar_SMTEncoding_Term.mk_and_l))
in (let _179_2194 = (let _179_2193 = (let _179_2192 = (let _179_2191 = (let _179_2190 = (mk_data_tester env l xx)
in ((_179_2190), (eqs)))
in (FStar_SMTEncoding_Term.mkAnd _179_2191))
in ((out), (_179_2192)))
in (FStar_SMTEncoding_Term.mkOr _179_2193))
in ((_179_2194), ((FStar_List.append decls decls'))))))
end))))
end))
end))
end)) ((FStar_SMTEncoding_Term.mkFalse), ([]))))
in (match (_86_2876) with
| (data_ax, decls) -> begin
(

let _86_2879 = (fresh_fvar "f" FStar_SMTEncoding_Term.Fuel_sort)
in (match (_86_2879) with
| (ffsym, ff) -> begin
(

let fuel_guarded_inversion = (

let xx_has_type_sfuel = if ((FStar_List.length datas) > (Prims.parse_int "1")) then begin
(let _179_2195 = (FStar_SMTEncoding_Term.mkApp (("SFuel"), ((ff)::[])))
in (FStar_SMTEncoding_Term.mk_HasTypeFuel _179_2195 xx tapp))
end else begin
(FStar_SMTEncoding_Term.mk_HasTypeFuel ff xx tapp)
end
in (let _179_2202 = (let _179_2201 = (let _179_2198 = (let _179_2197 = (add_fuel ((ffsym), (FStar_SMTEncoding_Term.Fuel_sort)) ((((xxsym), (FStar_SMTEncoding_Term.Term_sort)))::vars))
in (let _179_2196 = (FStar_SMTEncoding_Term.mkImp ((xx_has_type_sfuel), (data_ax)))
in ((((xx_has_type_sfuel)::[])::[]), (_179_2197), (_179_2196))))
in (FStar_SMTEncoding_Term.mkForall _179_2198))
in (let _179_2200 = (let _179_2199 = (varops.mk_unique (Prims.strcat "fuel_guarded_inversion_" t.FStar_Ident.str))
in Some (_179_2199))
in ((_179_2201), (Some ("inversion axiom")), (_179_2200))))
in FStar_SMTEncoding_Term.Assume (_179_2202)))
in (

let pattern_guarded_inversion = if ((contains_name env "Prims.inversion") && ((FStar_List.length datas) > (Prims.parse_int "1"))) then begin
(

let xx_has_type_fuel = (FStar_SMTEncoding_Term.mk_HasTypeFuel ff xx tapp)
in (

let pattern_guard = (FStar_SMTEncoding_Term.mkApp (("Prims.inversion"), ((tapp)::[])))
in (let _179_2210 = (let _179_2209 = (let _179_2208 = (let _179_2205 = (let _179_2204 = (add_fuel ((ffsym), (FStar_SMTEncoding_Term.Fuel_sort)) ((((xxsym), (FStar_SMTEncoding_Term.Term_sort)))::vars))
in (let _179_2203 = (FStar_SMTEncoding_Term.mkImp ((xx_has_type_fuel), (data_ax)))
in ((((xx_has_type_fuel)::(pattern_guard)::[])::[]), (_179_2204), (_179_2203))))
in (FStar_SMTEncoding_Term.mkForall _179_2205))
in (let _179_2207 = (let _179_2206 = (varops.mk_unique (Prims.strcat "pattern_guarded_inversion_" t.FStar_Ident.str))
in Some (_179_2206))
in ((_179_2208), (Some ("inversion axiom")), (_179_2207))))
in FStar_SMTEncoding_Term.Assume (_179_2209))
in (_179_2210)::[])))
end else begin
[]
end
in (FStar_List.append decls (FStar_List.append ((fuel_guarded_inversion)::[]) pattern_guarded_inversion))))
end))
end))
end))
end)
in (

let _86_2893 = (match ((let _179_2211 = (FStar_Syntax_Subst.compress k)
in _179_2211.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (formals, kres) -> begin
(((FStar_List.append tps formals)), ((FStar_Syntax_Util.comp_result kres)))
end
| _86_2890 -> begin
((tps), (k))
end)
in (match (_86_2893) with
| (formals, res) -> begin
(

let _86_2896 = (FStar_Syntax_Subst.open_term formals res)
in (match (_86_2896) with
| (formals, res) -> begin
(

let _86_2903 = (encode_binders None formals env)
in (match (_86_2903) with
| (vars, guards, env', binder_decls, _86_2902) -> begin
(

let _86_2907 = (new_term_constant_and_tok_from_lid env t)
in (match (_86_2907) with
| (tname, ttok, env) -> begin
(

let ttok_tm = (FStar_SMTEncoding_Term.mkApp ((ttok), ([])))
in (

let guard = (FStar_SMTEncoding_Term.mk_and_l guards)
in (

let tapp = (let _179_2213 = (let _179_2212 = (FStar_List.map FStar_SMTEncoding_Term.mkFreeV vars)
in ((tname), (_179_2212)))
in (FStar_SMTEncoding_Term.mkApp _179_2213))
in (

let _86_2928 = (

let tname_decl = (let _179_2217 = (let _179_2216 = (FStar_All.pipe_right vars (FStar_List.map (fun _86_2913 -> (match (_86_2913) with
| (n, s) -> begin
(((Prims.strcat tname n)), (s))
end))))
in (let _179_2215 = (varops.next_id ())
in ((tname), (_179_2216), (FStar_SMTEncoding_Term.Term_sort), (_179_2215), (false))))
in (constructor_or_logic_type_decl _179_2217))
in (

let _86_2925 = (match (vars) with
| [] -> begin
(let _179_2221 = (let _179_2220 = (let _179_2219 = (FStar_SMTEncoding_Term.mkApp ((tname), ([])))
in (FStar_All.pipe_left (fun _179_2218 -> Some (_179_2218)) _179_2219))
in (push_free_var env t tname _179_2220))
in (([]), (_179_2221)))
end
| _86_2917 -> begin
(

let ttok_decl = FStar_SMTEncoding_Term.DeclFun (((ttok), ([]), (FStar_SMTEncoding_Term.Term_sort), (Some ("token"))))
in (

let ttok_fresh = (let _179_2222 = (varops.next_id ())
in (FStar_SMTEncoding_Term.fresh_token ((ttok), (FStar_SMTEncoding_Term.Term_sort)) _179_2222))
in (

let ttok_app = (mk_Apply ttok_tm vars)
in (

let pats = ((ttok_app)::[])::((tapp)::[])::[]
in (

let name_tok_corr = (let _179_2226 = (let _179_2225 = (let _179_2224 = (let _179_2223 = (FStar_SMTEncoding_Term.mkEq ((ttok_app), (tapp)))
in ((pats), (None), (vars), (_179_2223)))
in (FStar_SMTEncoding_Term.mkForall' _179_2224))
in ((_179_2225), (Some ("name-token correspondence")), (Some ((Prims.strcat "token_correspondence_" ttok)))))
in FStar_SMTEncoding_Term.Assume (_179_2226))
in (((ttok_decl)::(ttok_fresh)::(name_tok_corr)::[]), (env)))))))
end)
in (match (_86_2925) with
| (tok_decls, env) -> begin
(((FStar_List.append tname_decl tok_decls)), (env))
end)))
in (match (_86_2928) with
| (decls, env) -> begin
(

let kindingAx = (

let _86_2931 = (encode_term_pred None res env' tapp)
in (match (_86_2931) with
| (k, decls) -> begin
(

let karr = if ((FStar_List.length formals) > (Prims.parse_int "0")) then begin
(let _179_2230 = (let _179_2229 = (let _179_2228 = (let _179_2227 = (FStar_SMTEncoding_Term.mk_PreType ttok_tm)
in (FStar_SMTEncoding_Term.mk_tester "Tm_arrow" _179_2227))
in ((_179_2228), (Some ("kinding")), (Some ((Prims.strcat "pre_kinding_" ttok)))))
in FStar_SMTEncoding_Term.Assume (_179_2229))
in (_179_2230)::[])
end else begin
[]
end
in (let _179_2237 = (let _179_2236 = (let _179_2235 = (let _179_2234 = (let _179_2233 = (let _179_2232 = (let _179_2231 = (FStar_SMTEncoding_Term.mkImp ((guard), (k)))
in ((((tapp)::[])::[]), (vars), (_179_2231)))
in (FStar_SMTEncoding_Term.mkForall _179_2232))
in ((_179_2233), (None), (Some ((Prims.strcat "kinding_" ttok)))))
in FStar_SMTEncoding_Term.Assume (_179_2234))
in (_179_2235)::[])
in (FStar_List.append karr _179_2236))
in (FStar_List.append decls _179_2237)))
end))
in (

let aux = (let _179_2241 = (let _179_2240 = (inversion_axioms tapp vars)
in (let _179_2239 = (let _179_2238 = (pretype_axiom tapp vars)
in (_179_2238)::[])
in (FStar_List.append _179_2240 _179_2239)))
in (FStar_List.append kindingAx _179_2241))
in (

let g = (FStar_List.append decls (FStar_List.append binder_decls aux))
in ((g), (env)))))
end)))))
end))
end))
end))
end)))))
end
| FStar_Syntax_Syntax.Sig_datacon (d, _86_2938, _86_2940, _86_2942, _86_2944, _86_2946, _86_2948, _86_2950) when (FStar_Ident.lid_equals d FStar_Syntax_Const.lexcons_lid) -> begin
(([]), (env))
end
| FStar_Syntax_Syntax.Sig_datacon (d, _86_2955, t, _86_2958, n_tps, quals, _86_2962, drange) -> begin
(

let _86_2969 = (new_term_constant_and_tok_from_lid env d)
in (match (_86_2969) with
| (ddconstrsym, ddtok, env) -> begin
(

let ddtok_tm = (FStar_SMTEncoding_Term.mkApp ((ddtok), ([])))
in (

let _86_2973 = (FStar_Syntax_Util.arrow_formals t)
in (match (_86_2973) with
| (formals, t_res) -> begin
(

let _86_2976 = (fresh_fvar "f" FStar_SMTEncoding_Term.Fuel_sort)
in (match (_86_2976) with
| (fuel_var, fuel_tm) -> begin
(

let s_fuel_tm = (FStar_SMTEncoding_Term.mkApp (("SFuel"), ((fuel_tm)::[])))
in (

let _86_2983 = (encode_binders (Some (fuel_tm)) formals env)
in (match (_86_2983) with
| (vars, guards, env', binder_decls, names) -> begin
(

let projectors = (FStar_All.pipe_right names (FStar_List.map (fun x -> (let _179_2243 = (mk_term_projector_name d x)
in ((_179_2243), (FStar_SMTEncoding_Term.Term_sort))))))
in (

let datacons = (let _179_2245 = (let _179_2244 = (varops.next_id ())
in ((ddconstrsym), (projectors), (FStar_SMTEncoding_Term.Term_sort), (_179_2244), (true)))
in (FStar_All.pipe_right _179_2245 FStar_SMTEncoding_Term.constructor_to_decl))
in (

let app = (mk_Apply ddtok_tm vars)
in (

let guard = (FStar_SMTEncoding_Term.mk_and_l guards)
in (

let xvars = (FStar_List.map FStar_SMTEncoding_Term.mkFreeV vars)
in (

let dapp = (FStar_SMTEncoding_Term.mkApp ((ddconstrsym), (xvars)))
in (

let _86_2993 = (encode_term_pred None t env ddtok_tm)
in (match (_86_2993) with
| (tok_typing, decls3) -> begin
(

let _86_3000 = (encode_binders (Some (fuel_tm)) formals env)
in (match (_86_3000) with
| (vars', guards', env'', decls_formals, _86_2999) -> begin
(

let _86_3005 = (

let xvars = (FStar_List.map FStar_SMTEncoding_Term.mkFreeV vars')
in (

let dapp = (FStar_SMTEncoding_Term.mkApp ((ddconstrsym), (xvars)))
in (encode_term_pred (Some (fuel_tm)) t_res env'' dapp)))
in (match (_86_3005) with
| (ty_pred', decls_pred) -> begin
(

let guard' = (FStar_SMTEncoding_Term.mk_and_l guards')
in (

let proxy_fresh = (match (formals) with
| [] -> begin
[]
end
| _86_3009 -> begin
(let _179_2247 = (let _179_2246 = (varops.next_id ())
in (FStar_SMTEncoding_Term.fresh_token ((ddtok), (FStar_SMTEncoding_Term.Term_sort)) _179_2246))
in (_179_2247)::[])
end)
in (

let encode_elim = (fun _86_3012 -> (match (()) with
| () -> begin
(

let _86_3015 = (FStar_Syntax_Util.head_and_args t_res)
in (match (_86_3015) with
| (head, args) -> begin
(match ((let _179_2250 = (FStar_Syntax_Subst.compress head)
in _179_2250.FStar_Syntax_Syntax.n)) with
| (FStar_Syntax_Syntax.Tm_uinst ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar (fv); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, _)) | (FStar_Syntax_Syntax.Tm_fvar (fv)) -> begin
(

let encoded_head = (lookup_free_var_name env' fv.FStar_Syntax_Syntax.fv_name)
in (

let _86_3033 = (encode_args args env')
in (match (_86_3033) with
| (encoded_args, arg_decls) -> begin
(

let _86_3048 = (FStar_List.fold_left (fun _86_3037 arg -> (match (_86_3037) with
| (env, arg_vars, eqns) -> begin
(

let _86_3043 = (let _179_2253 = (FStar_Syntax_Syntax.new_bv None FStar_Syntax_Syntax.tun)
in (gen_term_var env _179_2253))
in (match (_86_3043) with
| (_86_3040, xv, env) -> begin
(let _179_2255 = (let _179_2254 = (FStar_SMTEncoding_Term.mkEq ((arg), (xv)))
in (_179_2254)::eqns)
in ((env), ((xv)::arg_vars), (_179_2255)))
end))
end)) ((env'), ([]), ([])) encoded_args)
in (match (_86_3048) with
| (_86_3045, arg_vars, eqns) -> begin
(

let arg_vars = (FStar_List.rev arg_vars)
in (

let ty = (FStar_SMTEncoding_Term.mkApp ((encoded_head), (arg_vars)))
in (

let xvars = (FStar_List.map FStar_SMTEncoding_Term.mkFreeV vars)
in (

let dapp = (FStar_SMTEncoding_Term.mkApp ((ddconstrsym), (xvars)))
in (

let ty_pred = (FStar_SMTEncoding_Term.mk_HasTypeWithFuel (Some (s_fuel_tm)) dapp ty)
in (

let arg_binders = (FStar_List.map FStar_SMTEncoding_Term.fv_of_term arg_vars)
in (

let typing_inversion = (let _179_2262 = (let _179_2261 = (let _179_2260 = (let _179_2259 = (add_fuel ((fuel_var), (FStar_SMTEncoding_Term.Fuel_sort)) (FStar_List.append vars arg_binders))
in (let _179_2258 = (let _179_2257 = (let _179_2256 = (FStar_SMTEncoding_Term.mk_and_l (FStar_List.append eqns guards))
in ((ty_pred), (_179_2256)))
in (FStar_SMTEncoding_Term.mkImp _179_2257))
in ((((ty_pred)::[])::[]), (_179_2259), (_179_2258))))
in (FStar_SMTEncoding_Term.mkForall _179_2260))
in ((_179_2261), (Some ("data constructor typing elim")), (Some ((Prims.strcat "data_elim_" ddconstrsym)))))
in FStar_SMTEncoding_Term.Assume (_179_2262))
in (

let subterm_ordering = if (FStar_Ident.lid_equals d FStar_Syntax_Const.lextop_lid) then begin
(

let x = (let _179_2263 = (varops.fresh "x")
in ((_179_2263), (FStar_SMTEncoding_Term.Term_sort)))
in (

let xtm = (FStar_SMTEncoding_Term.mkFreeV x)
in (let _179_2275 = (let _179_2274 = (let _179_2271 = (let _179_2270 = (let _179_2265 = (let _179_2264 = (FStar_SMTEncoding_Term.mk_Precedes xtm dapp)
in (_179_2264)::[])
in (_179_2265)::[])
in (let _179_2269 = (let _179_2268 = (let _179_2267 = (FStar_SMTEncoding_Term.mk_tester "LexCons" xtm)
in (let _179_2266 = (FStar_SMTEncoding_Term.mk_Precedes xtm dapp)
in ((_179_2267), (_179_2266))))
in (FStar_SMTEncoding_Term.mkImp _179_2268))
in ((_179_2270), ((x)::[]), (_179_2269))))
in (FStar_SMTEncoding_Term.mkForall _179_2271))
in (let _179_2273 = (let _179_2272 = (varops.mk_unique "lextop")
in Some (_179_2272))
in ((_179_2274), (Some ("lextop is top")), (_179_2273))))
in FStar_SMTEncoding_Term.Assume (_179_2275))))
end else begin
(

let prec = (FStar_All.pipe_right vars (FStar_List.collect (fun v -> (match ((Prims.snd v)) with
| FStar_SMTEncoding_Term.Fuel_sort -> begin
[]
end
| FStar_SMTEncoding_Term.Term_sort -> begin
(let _179_2278 = (let _179_2277 = (FStar_SMTEncoding_Term.mkFreeV v)
in (FStar_SMTEncoding_Term.mk_Precedes _179_2277 dapp))
in (_179_2278)::[])
end
| _86_3062 -> begin
(FStar_All.failwith "unexpected sort")
end))))
in (let _179_2285 = (let _179_2284 = (let _179_2283 = (let _179_2282 = (add_fuel ((fuel_var), (FStar_SMTEncoding_Term.Fuel_sort)) (FStar_List.append vars arg_binders))
in (let _179_2281 = (let _179_2280 = (let _179_2279 = (FStar_SMTEncoding_Term.mk_and_l prec)
in ((ty_pred), (_179_2279)))
in (FStar_SMTEncoding_Term.mkImp _179_2280))
in ((((ty_pred)::[])::[]), (_179_2282), (_179_2281))))
in (FStar_SMTEncoding_Term.mkForall _179_2283))
in ((_179_2284), (Some ("subterm ordering")), (Some ((Prims.strcat "subterm_ordering_" ddconstrsym)))))
in FStar_SMTEncoding_Term.Assume (_179_2285)))
end
in ((arg_decls), ((typing_inversion)::(subterm_ordering)::[]))))))))))
end))
end)))
end
| _86_3066 -> begin
(

let _86_3067 = (let _179_2288 = (let _179_2287 = (FStar_Syntax_Print.lid_to_string d)
in (let _179_2286 = (FStar_Syntax_Print.term_to_string head)
in (FStar_Util.format2 "Constructor %s builds an unexpected type %s\n" _179_2287 _179_2286)))
in (FStar_TypeChecker_Errors.warn drange _179_2288))
in (([]), ([])))
end)
end))
end))
in (

let _86_3071 = (encode_elim ())
in (match (_86_3071) with
| (decls2, elim) -> begin
(

let g = (let _179_2315 = (let _179_2314 = (let _179_2313 = (let _179_2312 = (let _179_2293 = (let _179_2292 = (let _179_2291 = (let _179_2290 = (let _179_2289 = (FStar_Syntax_Print.lid_to_string d)
in (FStar_Util.format1 "data constructor proxy: %s" _179_2289))
in Some (_179_2290))
in ((ddtok), ([]), (FStar_SMTEncoding_Term.Term_sort), (_179_2291)))
in FStar_SMTEncoding_Term.DeclFun (_179_2292))
in (_179_2293)::[])
in (let _179_2311 = (let _179_2310 = (let _179_2309 = (let _179_2308 = (let _179_2307 = (let _179_2306 = (let _179_2305 = (let _179_2297 = (let _179_2296 = (let _179_2295 = (let _179_2294 = (FStar_SMTEncoding_Term.mkEq ((app), (dapp)))
in ((((app)::[])::[]), (vars), (_179_2294)))
in (FStar_SMTEncoding_Term.mkForall _179_2295))
in ((_179_2296), (Some ("equality for proxy")), (Some ((Prims.strcat "equality_tok_" ddtok)))))
in FStar_SMTEncoding_Term.Assume (_179_2297))
in (let _179_2304 = (let _179_2303 = (let _179_2302 = (let _179_2301 = (let _179_2300 = (let _179_2299 = (add_fuel ((fuel_var), (FStar_SMTEncoding_Term.Fuel_sort)) vars')
in (let _179_2298 = (FStar_SMTEncoding_Term.mkImp ((guard'), (ty_pred')))
in ((((ty_pred')::[])::[]), (_179_2299), (_179_2298))))
in (FStar_SMTEncoding_Term.mkForall _179_2300))
in ((_179_2301), (Some ("data constructor typing intro")), (Some ((Prims.strcat "data_typing_intro_" ddtok)))))
in FStar_SMTEncoding_Term.Assume (_179_2302))
in (_179_2303)::[])
in (_179_2305)::_179_2304))
in (FStar_SMTEncoding_Term.Assume (((tok_typing), (Some ("typing for data constructor proxy")), (Some ((Prims.strcat "typing_tok_" ddtok))))))::_179_2306)
in (FStar_List.append _179_2307 elim))
in (FStar_List.append decls_pred _179_2308))
in (FStar_List.append decls_formals _179_2309))
in (FStar_List.append proxy_fresh _179_2310))
in (FStar_List.append _179_2312 _179_2311)))
in (FStar_List.append decls3 _179_2313))
in (FStar_List.append decls2 _179_2314))
in (FStar_List.append binder_decls _179_2315))
in (((FStar_List.append datacons g)), (env)))
end)))))
end))
end))
end))))))))
end)))
end))
end)))
end))
end)))
and encode_signature : env_t  ->  FStar_Syntax_Syntax.sigelt Prims.list  ->  (FStar_SMTEncoding_Term.decl Prims.list * env_t) = (fun env ses -> (FStar_All.pipe_right ses (FStar_List.fold_left (fun _86_3077 se -> (match (_86_3077) with
| (g, env) -> begin
(

let _86_3081 = (encode_sigelt env se)
in (match (_86_3081) with
| (g', env) -> begin
(((FStar_List.append g g')), (env))
end))
end)) (([]), (env)))))


let encode_env_bindings : env_t  ->  FStar_TypeChecker_Env.binding Prims.list  ->  (FStar_SMTEncoding_Term.decls_t * env_t) = (fun env bindings -> (

let encode_binding = (fun b _86_3089 -> (match (_86_3089) with
| (i, decls, env) -> begin
(match (b) with
| FStar_TypeChecker_Env.Binding_univ (_86_3091) -> begin
(((i + (Prims.parse_int "1"))), ([]), (env))
end
| FStar_TypeChecker_Env.Binding_var (x) -> begin
(

let t1 = (FStar_TypeChecker_Normalize.normalize ((FStar_TypeChecker_Normalize.Beta)::(FStar_TypeChecker_Normalize.Inline)::(FStar_TypeChecker_Normalize.Simplify)::(FStar_TypeChecker_Normalize.EraseUniverses)::[]) env.tcenv x.FStar_Syntax_Syntax.sort)
in (

let _86_3096 = if (FStar_All.pipe_left (FStar_TypeChecker_Env.debug env.tcenv) (FStar_Options.Other ("SMTEncoding"))) then begin
(let _179_2330 = (FStar_Syntax_Print.bv_to_string x)
in (let _179_2329 = (FStar_Syntax_Print.term_to_string x.FStar_Syntax_Syntax.sort)
in (let _179_2328 = (FStar_Syntax_Print.term_to_string t1)
in (FStar_Util.print3 "Normalized %s : %s to %s\n" _179_2330 _179_2329 _179_2328))))
end else begin
()
end
in (

let _86_3100 = (encode_term t1 env)
in (match (_86_3100) with
| (t, decls') -> begin
(

let _86_3104 = (let _179_2335 = (let _179_2334 = (let _179_2333 = (FStar_Util.digest_of_string t.FStar_SMTEncoding_Term.hash)
in (let _179_2332 = (let _179_2331 = (FStar_Util.string_of_int i)
in (Prims.strcat "_" _179_2331))
in (Prims.strcat _179_2333 _179_2332)))
in (Prims.strcat "x_" _179_2334))
in (new_term_constant_from_string env x _179_2335))
in (match (_86_3104) with
| (xxsym, xx, env') -> begin
(

let t = (FStar_SMTEncoding_Term.mk_HasTypeWithFuel None xx t)
in (

let caption = if (FStar_Options.log_queries ()) then begin
(let _179_2339 = (let _179_2338 = (FStar_Syntax_Print.bv_to_string x)
in (let _179_2337 = (FStar_Syntax_Print.term_to_string x.FStar_Syntax_Syntax.sort)
in (let _179_2336 = (FStar_Syntax_Print.term_to_string t1)
in (FStar_Util.format3 "%s : %s (%s)" _179_2338 _179_2337 _179_2336))))
in Some (_179_2339))
end else begin
None
end
in (

let ax = (

let a_name = Some ((Prims.strcat "binder_" xxsym))
in FStar_SMTEncoding_Term.Assume (((t), (a_name), (a_name))))
in (

let g = (FStar_List.append ((FStar_SMTEncoding_Term.DeclFun (((xxsym), ([]), (FStar_SMTEncoding_Term.Term_sort), (caption))))::[]) (FStar_List.append decls' ((ax)::[])))
in (((i + (Prims.parse_int "1"))), ((FStar_List.append decls g)), (env'))))))
end))
end))))
end
| FStar_TypeChecker_Env.Binding_lid (x, (_86_3112, t)) -> begin
(

let t_norm = (whnf env t)
in (

let fv = (FStar_Syntax_Syntax.lid_as_fv x FStar_Syntax_Syntax.Delta_constant None)
in (

let _86_3121 = (encode_free_var env fv t t_norm [])
in (match (_86_3121) with
| (g, env') -> begin
(((i + (Prims.parse_int "1"))), ((FStar_List.append decls g)), (env'))
end))))
end
| (FStar_TypeChecker_Env.Binding_sig_inst (_, se, _)) | (FStar_TypeChecker_Env.Binding_sig (_, se)) -> begin
(

let _86_3135 = (encode_sigelt env se)
in (match (_86_3135) with
| (g, env') -> begin
(((i + (Prims.parse_int "1"))), ((FStar_List.append decls g)), (env'))
end))
end)
end))
in (

let _86_3140 = (FStar_List.fold_right encode_binding bindings (((Prims.parse_int "0")), ([]), (env)))
in (match (_86_3140) with
| (_86_3137, decls, env) -> begin
((decls), (env))
end))))


let encode_labels = (fun labs -> (

let prefix = (FStar_All.pipe_right labs (FStar_List.map (fun _86_3147 -> (match (_86_3147) with
| (l, _86_3144, _86_3146) -> begin
FStar_SMTEncoding_Term.DeclFun ((((Prims.fst l)), ([]), (FStar_SMTEncoding_Term.Bool_sort), (None)))
end))))
in (

let suffix = (FStar_All.pipe_right labs (FStar_List.collect (fun _86_3154 -> (match (_86_3154) with
| (l, _86_3151, _86_3153) -> begin
(let _179_2347 = (FStar_All.pipe_left (fun _179_2343 -> FStar_SMTEncoding_Term.Echo (_179_2343)) (Prims.fst l))
in (let _179_2346 = (let _179_2345 = (let _179_2344 = (FStar_SMTEncoding_Term.mkFreeV l)
in FStar_SMTEncoding_Term.Eval (_179_2344))
in (_179_2345)::[])
in (_179_2347)::_179_2346))
end))))
in ((prefix), (suffix)))))


let last_env : env_t Prims.list FStar_ST.ref = (FStar_Util.mk_ref [])


let init_env : FStar_TypeChecker_Env.env  ->  Prims.unit = (fun tcenv -> (let _179_2352 = (let _179_2351 = (let _179_2350 = (FStar_Util.smap_create (Prims.parse_int "100"))
in {bindings = []; depth = (Prims.parse_int "0"); tcenv = tcenv; warn = true; cache = _179_2350; nolabels = false; use_zfuel_name = false; encode_non_total_function_typ = true})
in (_179_2351)::[])
in (FStar_ST.op_Colon_Equals last_env _179_2352)))


let get_env : FStar_TypeChecker_Env.env  ->  env_t = (fun tcenv -> (match ((FStar_ST.read last_env)) with
| [] -> begin
(FStar_All.failwith "No env; call init first!")
end
| (e)::_86_3160 -> begin
(

let _86_3163 = e
in {bindings = _86_3163.bindings; depth = _86_3163.depth; tcenv = tcenv; warn = _86_3163.warn; cache = _86_3163.cache; nolabels = _86_3163.nolabels; use_zfuel_name = _86_3163.use_zfuel_name; encode_non_total_function_typ = _86_3163.encode_non_total_function_typ})
end))


let set_env : env_t  ->  Prims.unit = (fun env -> (match ((FStar_ST.read last_env)) with
| [] -> begin
(FStar_All.failwith "Empty env stack")
end
| (_86_3169)::tl -> begin
(FStar_ST.op_Colon_Equals last_env ((env)::tl))
end))


let push_env : Prims.unit  ->  Prims.unit = (fun _86_3171 -> (match (()) with
| () -> begin
(match ((FStar_ST.read last_env)) with
| [] -> begin
(FStar_All.failwith "Empty env stack")
end
| (hd)::tl -> begin
(

let refs = (FStar_Util.smap_copy hd.cache)
in (

let top = (

let _86_3177 = hd
in {bindings = _86_3177.bindings; depth = _86_3177.depth; tcenv = _86_3177.tcenv; warn = _86_3177.warn; cache = refs; nolabels = _86_3177.nolabels; use_zfuel_name = _86_3177.use_zfuel_name; encode_non_total_function_typ = _86_3177.encode_non_total_function_typ})
in (FStar_ST.op_Colon_Equals last_env ((top)::(hd)::tl))))
end)
end))


let pop_env : Prims.unit  ->  Prims.unit = (fun _86_3180 -> (match (()) with
| () -> begin
(match ((FStar_ST.read last_env)) with
| [] -> begin
(FStar_All.failwith "Popping an empty stack")
end
| (_86_3184)::tl -> begin
(FStar_ST.op_Colon_Equals last_env tl)
end)
end))


let mark_env : Prims.unit  ->  Prims.unit = (fun _86_3186 -> (match (()) with
| () -> begin
(push_env ())
end))


let reset_mark_env : Prims.unit  ->  Prims.unit = (fun _86_3187 -> (match (()) with
| () -> begin
(pop_env ())
end))


let commit_mark_env : Prims.unit  ->  Prims.unit = (fun _86_3188 -> (match (()) with
| () -> begin
(match ((FStar_ST.read last_env)) with
| (hd)::(_86_3191)::tl -> begin
(FStar_ST.op_Colon_Equals last_env ((hd)::tl))
end
| _86_3196 -> begin
(FStar_All.failwith "Impossible")
end)
end))


let init : FStar_TypeChecker_Env.env  ->  Prims.unit = (fun tcenv -> (

let _86_3198 = (init_env tcenv)
in (

let _86_3200 = (FStar_SMTEncoding_Z3.init ())
in (FStar_SMTEncoding_Z3.giveZ3 ((FStar_SMTEncoding_Term.DefPrelude)::[])))))


let push : Prims.string  ->  Prims.unit = (fun msg -> (

let _86_3203 = (push_env ())
in (

let _86_3205 = (varops.push ())
in (FStar_SMTEncoding_Z3.push msg))))


let pop : Prims.string  ->  Prims.unit = (fun msg -> (

let _86_3208 = (let _179_2373 = (pop_env ())
in (FStar_All.pipe_left Prims.ignore _179_2373))
in (

let _86_3210 = (varops.pop ())
in (FStar_SMTEncoding_Z3.pop msg))))


let mark : Prims.string  ->  Prims.unit = (fun msg -> (

let _86_3213 = (mark_env ())
in (

let _86_3215 = (varops.mark ())
in (FStar_SMTEncoding_Z3.mark msg))))


let reset_mark : Prims.string  ->  Prims.unit = (fun msg -> (

let _86_3218 = (reset_mark_env ())
in (

let _86_3220 = (varops.reset_mark ())
in (FStar_SMTEncoding_Z3.reset_mark msg))))


let commit_mark = (fun msg -> (

let _86_3223 = (commit_mark_env ())
in (

let _86_3225 = (varops.commit_mark ())
in (FStar_SMTEncoding_Z3.commit_mark msg))))


let encode_sig : FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.sigelt  ->  Prims.unit = (fun tcenv se -> (

let caption = (fun decls -> if (FStar_Options.log_queries ()) then begin
(let _179_2389 = (let _179_2388 = (let _179_2387 = (let _179_2386 = (let _179_2385 = (FStar_Syntax_Util.lids_of_sigelt se)
in (FStar_All.pipe_right _179_2385 (FStar_List.map FStar_Syntax_Print.lid_to_string)))
in (FStar_All.pipe_right _179_2386 (FStar_String.concat ", ")))
in (Prims.strcat "encoding sigelt " _179_2387))
in FStar_SMTEncoding_Term.Caption (_179_2388))
in (_179_2389)::decls)
end else begin
decls
end)
in (

let env = (get_env tcenv)
in (

let _86_3234 = (encode_sigelt env se)
in (match (_86_3234) with
| (decls, env) -> begin
(

let _86_3235 = (set_env env)
in (let _179_2390 = (caption decls)
in (FStar_SMTEncoding_Z3.giveZ3 _179_2390)))
end)))))


let encode_modul : FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.modul  ->  Prims.unit = (fun tcenv modul -> (

let name = (FStar_Util.format2 "%s %s" (if modul.FStar_Syntax_Syntax.is_interface then begin
"interface"
end else begin
"module"
end) modul.FStar_Syntax_Syntax.name.FStar_Ident.str)
in (

let _86_3240 = if (FStar_TypeChecker_Env.debug tcenv FStar_Options.Low) then begin
(let _179_2395 = (FStar_All.pipe_right (FStar_List.length modul.FStar_Syntax_Syntax.exports) FStar_Util.string_of_int)
in (FStar_Util.print2 "+++++++++++Encoding externals for %s ... %s exports\n" name _179_2395))
end else begin
()
end
in (

let env = (get_env tcenv)
in (

let _86_3247 = (encode_signature (

let _86_3243 = env
in {bindings = _86_3243.bindings; depth = _86_3243.depth; tcenv = _86_3243.tcenv; warn = false; cache = _86_3243.cache; nolabels = _86_3243.nolabels; use_zfuel_name = _86_3243.use_zfuel_name; encode_non_total_function_typ = _86_3243.encode_non_total_function_typ}) modul.FStar_Syntax_Syntax.exports)
in (match (_86_3247) with
| (decls, env) -> begin
(

let caption = (fun decls -> if (FStar_Options.log_queries ()) then begin
(

let msg = (Prims.strcat "Externals for " name)
in (FStar_List.append ((FStar_SMTEncoding_Term.Caption (msg))::decls) ((FStar_SMTEncoding_Term.Caption ((Prims.strcat "End " msg)))::[])))
end else begin
decls
end)
in (

let _86_3253 = (set_env (

let _86_3251 = env
in {bindings = _86_3251.bindings; depth = _86_3251.depth; tcenv = _86_3251.tcenv; warn = true; cache = _86_3251.cache; nolabels = _86_3251.nolabels; use_zfuel_name = _86_3251.use_zfuel_name; encode_non_total_function_typ = _86_3251.encode_non_total_function_typ}))
in (

let _86_3255 = if (FStar_TypeChecker_Env.debug tcenv FStar_Options.Low) then begin
(FStar_Util.print1 "Done encoding externals for %s\n" name)
end else begin
()
end
in (

let decls = (caption decls)
in (FStar_SMTEncoding_Z3.giveZ3 decls)))))
end))))))


let encode_query : (Prims.unit  ->  Prims.string) Prims.option  ->  FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.typ  ->  (FStar_SMTEncoding_Term.decl Prims.list * FStar_SMTEncoding_ErrorReporting.label Prims.list * FStar_SMTEncoding_Term.decl * FStar_SMTEncoding_Term.decl Prims.list) = (fun use_env_msg tcenv q -> (

let _86_3261 = (let _179_2413 = (let _179_2412 = (FStar_TypeChecker_Env.current_module tcenv)
in _179_2412.FStar_Ident.str)
in (FStar_SMTEncoding_Z3.query_logging.FStar_SMTEncoding_Z3.set_module_name _179_2413))
in (

let env = (get_env tcenv)
in (

let bindings = (FStar_TypeChecker_Env.fold_env tcenv (fun bs b -> (b)::bs) [])
in (

let _86_3286 = (

let rec aux = (fun bindings -> (match (bindings) with
| (FStar_TypeChecker_Env.Binding_var (x))::rest -> begin
(

let _86_3275 = (aux rest)
in (match (_86_3275) with
| (out, rest) -> begin
(

let t = (FStar_TypeChecker_Normalize.normalize ((FStar_TypeChecker_Normalize.Inline)::(FStar_TypeChecker_Normalize.Beta)::(FStar_TypeChecker_Normalize.Simplify)::(FStar_TypeChecker_Normalize.EraseUniverses)::[]) env.tcenv x.FStar_Syntax_Syntax.sort)
in (let _179_2419 = (let _179_2418 = (FStar_Syntax_Syntax.mk_binder (

let _86_3277 = x
in {FStar_Syntax_Syntax.ppname = _86_3277.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _86_3277.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = t}))
in (_179_2418)::out)
in ((_179_2419), (rest))))
end))
end
| _86_3280 -> begin
(([]), (bindings))
end))
in (

let _86_3283 = (aux bindings)
in (match (_86_3283) with
| (closing, bindings) -> begin
(let _179_2420 = (FStar_Syntax_Util.close_forall (FStar_List.rev closing) q)
in ((_179_2420), (bindings)))
end)))
in (match (_86_3286) with
| (q, bindings) -> begin
(

let _86_3295 = (let _179_2422 = (FStar_List.filter (fun _86_24 -> (match (_86_24) with
| FStar_TypeChecker_Env.Binding_sig (_86_3289) -> begin
false
end
| _86_3292 -> begin
true
end)) bindings)
in (encode_env_bindings env _179_2422))
in (match (_86_3295) with
| (env_decls, env) -> begin
(

let _86_3296 = if (((FStar_TypeChecker_Env.debug tcenv FStar_Options.Low) || (FStar_All.pipe_left (FStar_TypeChecker_Env.debug tcenv) (FStar_Options.Other ("SMTEncoding")))) || (FStar_All.pipe_left (FStar_TypeChecker_Env.debug tcenv) (FStar_Options.Other ("SMTQuery")))) then begin
(let _179_2423 = (FStar_Syntax_Print.term_to_string q)
in (FStar_Util.print1 "Encoding query formula: %s\n" _179_2423))
end else begin
()
end
in (

let _86_3300 = (encode_formula q env)
in (match (_86_3300) with
| (phi, qdecls) -> begin
(

let _86_3305 = (let _179_2424 = (FStar_TypeChecker_Env.get_range tcenv)
in (FStar_SMTEncoding_ErrorReporting.label_goals use_env_msg _179_2424 phi))
in (match (_86_3305) with
| (phi, labels, _86_3304) -> begin
(

let _86_3308 = (encode_labels labels)
in (match (_86_3308) with
| (label_prefix, label_suffix) -> begin
(

let query_prelude = (FStar_List.append env_decls (FStar_List.append label_prefix qdecls))
in (

let qry = (let _179_2428 = (let _179_2427 = (FStar_SMTEncoding_Term.mkNot phi)
in (let _179_2426 = (let _179_2425 = (varops.mk_unique "@query")
in Some (_179_2425))
in ((_179_2427), (Some ("query")), (_179_2426))))
in FStar_SMTEncoding_Term.Assume (_179_2428))
in (

let suffix = (FStar_List.append label_suffix ((FStar_SMTEncoding_Term.Echo ("Done!"))::[]))
in ((query_prelude), (labels), (qry), (suffix)))))
end))
end))
end)))
end))
end))))))


let is_trivial : FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.typ  ->  Prims.bool = (fun tcenv q -> (

let env = (get_env tcenv)
in (

let _86_3315 = (push "query")
in (

let _86_3320 = (encode_formula q env)
in (match (_86_3320) with
| (f, _86_3319) -> begin
(

let _86_3321 = (pop "query")
in (match (f.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.True, _86_3325) -> begin
true
end
| _86_3329 -> begin
false
end))
end)))))




