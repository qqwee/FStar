open Prims
type verify_mode =
  | VerifyAll 
  | VerifyUserList 
  | VerifyFigureItOut 
let (uu___is_VerifyAll : verify_mode -> Prims.bool) =
  fun projectee  ->
    match projectee with | VerifyAll  -> true | uu____50504 -> false
  
let (uu___is_VerifyUserList : verify_mode -> Prims.bool) =
  fun projectee  ->
    match projectee with | VerifyUserList  -> true | uu____50515 -> false
  
let (uu___is_VerifyFigureItOut : verify_mode -> Prims.bool) =
  fun projectee  ->
    match projectee with | VerifyFigureItOut  -> true | uu____50526 -> false
  
type files_for_module_name =
  (Prims.string FStar_Pervasives_Native.option * Prims.string
    FStar_Pervasives_Native.option) FStar_Util.smap
type color =
  | White 
  | Gray 
  | Black 
let (uu___is_White : color -> Prims.bool) =
  fun projectee  ->
    match projectee with | White  -> true | uu____50549 -> false
  
let (uu___is_Gray : color -> Prims.bool) =
  fun projectee  ->
    match projectee with | Gray  -> true | uu____50560 -> false
  
let (uu___is_Black : color -> Prims.bool) =
  fun projectee  ->
    match projectee with | Black  -> true | uu____50571 -> false
  
type open_kind =
  | Open_module 
  | Open_namespace 
let (uu___is_Open_module : open_kind -> Prims.bool) =
  fun projectee  ->
    match projectee with | Open_module  -> true | uu____50582 -> false
  
let (uu___is_Open_namespace : open_kind -> Prims.bool) =
  fun projectee  ->
    match projectee with | Open_namespace  -> true | uu____50593 -> false
  
let (check_and_strip_suffix :
  Prims.string -> Prims.string FStar_Pervasives_Native.option) =
  fun f  ->
    let suffixes = [".fsti"; ".fst"; ".fsi"; ".fs"]  in
    let matches =
      FStar_List.map
        (fun ext  ->
           let lext = FStar_String.length ext  in
           let l = FStar_String.length f  in
           let uu____50641 =
             (l > lext) &&
               (let uu____50654 = FStar_String.substring f (l - lext) lext
                   in
                uu____50654 = ext)
              in
           if uu____50641
           then
             let uu____50675 =
               FStar_String.substring f (Prims.parse_int "0") (l - lext)  in
             FStar_Pervasives_Native.Some uu____50675
           else FStar_Pervasives_Native.None) suffixes
       in
    let uu____50692 = FStar_List.filter FStar_Util.is_some matches  in
    match uu____50692 with
    | (FStar_Pervasives_Native.Some m)::uu____50706 ->
        FStar_Pervasives_Native.Some m
    | uu____50718 -> FStar_Pervasives_Native.None
  
let (is_interface : Prims.string -> Prims.bool) =
  fun f  ->
    let uu____50735 =
      FStar_String.get f ((FStar_String.length f) - (Prims.parse_int "1"))
       in
    uu____50735 = 105
  
let (is_implementation : Prims.string -> Prims.bool) =
  fun f  ->
    let uu____50749 = is_interface f  in Prims.op_Negation uu____50749
  
let list_of_option :
  'Auu____50756 .
    'Auu____50756 FStar_Pervasives_Native.option -> 'Auu____50756 Prims.list
  =
  fun uu___423_50765  ->
    match uu___423_50765 with
    | FStar_Pervasives_Native.Some x -> [x]
    | FStar_Pervasives_Native.None  -> []
  
let list_of_pair :
  'Auu____50774 .
    ('Auu____50774 FStar_Pervasives_Native.option * 'Auu____50774
      FStar_Pervasives_Native.option) -> 'Auu____50774 Prims.list
  =
  fun uu____50789  ->
    match uu____50789 with
    | (intf,impl) ->
        FStar_List.append (list_of_option intf) (list_of_option impl)
  
let (module_name_of_file : Prims.string -> Prims.string) =
  fun f  ->
    let uu____50817 =
      let uu____50821 = FStar_Util.basename f  in
      check_and_strip_suffix uu____50821  in
    match uu____50817 with
    | FStar_Pervasives_Native.Some longname -> longname
    | FStar_Pervasives_Native.None  ->
        let uu____50828 =
          let uu____50834 = FStar_Util.format1 "not a valid FStar file: %s" f
             in
          (FStar_Errors.Fatal_NotValidFStarFile, uu____50834)  in
        FStar_Errors.raise_err uu____50828
  
let (lowercase_module_name : Prims.string -> Prims.string) =
  fun f  ->
    let uu____50848 = module_name_of_file f  in
    FStar_String.lowercase uu____50848
  
let (namespace_of_module :
  Prims.string -> FStar_Ident.lident FStar_Pervasives_Native.option) =
  fun f  ->
    let lid =
      let uu____50861 = FStar_Ident.path_of_text f  in
      FStar_Ident.lid_of_path uu____50861 FStar_Range.dummyRange  in
    match lid.FStar_Ident.ns with
    | [] -> FStar_Pervasives_Native.None
    | uu____50864 ->
        let uu____50867 = FStar_Ident.lid_of_ids lid.FStar_Ident.ns  in
        FStar_Pervasives_Native.Some uu____50867
  
type file_name = Prims.string
type module_name = Prims.string
type dependence =
  | UseInterface of module_name 
  | PreferInterface of module_name 
  | UseImplementation of module_name 
  | FriendImplementation of module_name 
let (uu___is_UseInterface : dependence -> Prims.bool) =
  fun projectee  ->
    match projectee with | UseInterface _0 -> true | uu____50909 -> false
  
let (__proj__UseInterface__item___0 : dependence -> module_name) =
  fun projectee  -> match projectee with | UseInterface _0 -> _0 
let (uu___is_PreferInterface : dependence -> Prims.bool) =
  fun projectee  ->
    match projectee with | PreferInterface _0 -> true | uu____50933 -> false
  
let (__proj__PreferInterface__item___0 : dependence -> module_name) =
  fun projectee  -> match projectee with | PreferInterface _0 -> _0 
let (uu___is_UseImplementation : dependence -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | UseImplementation _0 -> true
    | uu____50957 -> false
  
let (__proj__UseImplementation__item___0 : dependence -> module_name) =
  fun projectee  -> match projectee with | UseImplementation _0 -> _0 
let (uu___is_FriendImplementation : dependence -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | FriendImplementation _0 -> true
    | uu____50981 -> false
  
let (__proj__FriendImplementation__item___0 : dependence -> module_name) =
  fun projectee  -> match projectee with | FriendImplementation _0 -> _0 
let (dep_to_string : dependence -> Prims.string) =
  fun uu___424_51000  ->
    match uu___424_51000 with
    | UseInterface f -> FStar_String.op_Hat "UseInterface " f
    | PreferInterface f -> FStar_String.op_Hat "PreferInterface " f
    | UseImplementation f -> FStar_String.op_Hat "UseImplementation " f
    | FriendImplementation f -> FStar_String.op_Hat "FriendImplementation " f
  
type dependences = dependence Prims.list
let empty_dependences : 'Auu____51019 . unit -> 'Auu____51019 Prims.list =
  fun uu____51022  -> [] 
type dep_node = {
  edges: dependences ;
  color: color }
let (__proj__Mkdep_node__item__edges : dep_node -> dependences) =
  fun projectee  -> match projectee with | { edges; color;_} -> edges 
let (__proj__Mkdep_node__item__color : dep_node -> color) =
  fun projectee  -> match projectee with | { edges; color;_} -> color 
type dependence_graph =
  | Deps of dep_node FStar_Util.smap 
let (uu___is_Deps : dependence_graph -> Prims.bool) = fun projectee  -> true 
let (__proj__Deps__item___0 : dependence_graph -> dep_node FStar_Util.smap) =
  fun projectee  -> match projectee with | Deps _0 -> _0 
type parsing_data =
  {
  direct_deps: dependence Prims.list ;
  additional_roots: dependence Prims.list ;
  has_inline_for_extraction: Prims.bool }
let (__proj__Mkparsing_data__item__direct_deps :
  parsing_data -> dependence Prims.list) =
  fun projectee  ->
    match projectee with
    | { direct_deps; additional_roots; has_inline_for_extraction;_} ->
        direct_deps
  
let (__proj__Mkparsing_data__item__additional_roots :
  parsing_data -> dependence Prims.list) =
  fun projectee  ->
    match projectee with
    | { direct_deps; additional_roots; has_inline_for_extraction;_} ->
        additional_roots
  
let (__proj__Mkparsing_data__item__has_inline_for_extraction :
  parsing_data -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | { direct_deps; additional_roots; has_inline_for_extraction;_} ->
        has_inline_for_extraction
  
let (empty_parsing_data : parsing_data) =
  {
    direct_deps = [];
    additional_roots = [];
    has_inline_for_extraction = false
  } 
type deps =
  {
  dep_graph: dependence_graph ;
  file_system_map: files_for_module_name ;
  cmd_line_files: file_name Prims.list ;
  all_files: file_name Prims.list ;
  interfaces_with_inlining: module_name Prims.list ;
  parse_results: parsing_data FStar_Util.smap }
let (__proj__Mkdeps__item__dep_graph : deps -> dependence_graph) =
  fun projectee  ->
    match projectee with
    | { dep_graph; file_system_map; cmd_line_files; all_files;
        interfaces_with_inlining; parse_results;_} -> dep_graph
  
let (__proj__Mkdeps__item__file_system_map : deps -> files_for_module_name) =
  fun projectee  ->
    match projectee with
    | { dep_graph; file_system_map; cmd_line_files; all_files;
        interfaces_with_inlining; parse_results;_} -> file_system_map
  
let (__proj__Mkdeps__item__cmd_line_files : deps -> file_name Prims.list) =
  fun projectee  ->
    match projectee with
    | { dep_graph; file_system_map; cmd_line_files; all_files;
        interfaces_with_inlining; parse_results;_} -> cmd_line_files
  
let (__proj__Mkdeps__item__all_files : deps -> file_name Prims.list) =
  fun projectee  ->
    match projectee with
    | { dep_graph; file_system_map; cmd_line_files; all_files;
        interfaces_with_inlining; parse_results;_} -> all_files
  
let (__proj__Mkdeps__item__interfaces_with_inlining :
  deps -> module_name Prims.list) =
  fun projectee  ->
    match projectee with
    | { dep_graph; file_system_map; cmd_line_files; all_files;
        interfaces_with_inlining; parse_results;_} ->
        interfaces_with_inlining
  
let (__proj__Mkdeps__item__parse_results :
  deps -> parsing_data FStar_Util.smap) =
  fun projectee  ->
    match projectee with
    | { dep_graph; file_system_map; cmd_line_files; all_files;
        interfaces_with_inlining; parse_results;_} -> parse_results
  
let (deps_try_find :
  dependence_graph -> Prims.string -> dep_node FStar_Pervasives_Native.option)
  =
  fun uu____51364  ->
    fun k  -> match uu____51364 with | Deps m -> FStar_Util.smap_try_find m k
  
let (deps_add_dep : dependence_graph -> Prims.string -> dep_node -> unit) =
  fun uu____51386  ->
    fun k  ->
      fun v1  ->
        match uu____51386 with | Deps m -> FStar_Util.smap_add m k v1
  
let (deps_keys : dependence_graph -> Prims.string Prims.list) =
  fun uu____51401  ->
    match uu____51401 with | Deps m -> FStar_Util.smap_keys m
  
let (deps_empty : unit -> dependence_graph) =
  fun uu____51413  ->
    let uu____51414 = FStar_Util.smap_create (Prims.parse_int "41")  in
    Deps uu____51414
  
let (mk_deps :
  dependence_graph ->
    files_for_module_name ->
      file_name Prims.list ->
        file_name Prims.list ->
          module_name Prims.list -> parsing_data FStar_Util.smap -> deps)
  =
  fun dg  ->
    fun fs  ->
      fun c  ->
        fun a  ->
          fun i  ->
            fun pr  ->
              {
                dep_graph = dg;
                file_system_map = fs;
                cmd_line_files = c;
                all_files = a;
                interfaces_with_inlining = i;
                parse_results = pr
              }
  
let (empty_deps : deps) =
  let uu____51472 = deps_empty ()  in
  let uu____51473 = FStar_Util.smap_create (Prims.parse_int "0")  in
  let uu____51485 = FStar_Util.smap_create (Prims.parse_int "0")  in
  mk_deps uu____51472 uu____51473 [] [] [] uu____51485 
let (module_name_of_dep : dependence -> module_name) =
  fun uu___425_51498  ->
    match uu___425_51498 with
    | UseInterface m -> m
    | PreferInterface m -> m
    | UseImplementation m -> m
    | FriendImplementation m -> m
  
let (resolve_module_name :
  files_for_module_name ->
    module_name -> module_name FStar_Pervasives_Native.option)
  =
  fun file_system_map  ->
    fun key  ->
      let uu____51527 = FStar_Util.smap_try_find file_system_map key  in
      match uu____51527 with
      | FStar_Pervasives_Native.Some
          (FStar_Pervasives_Native.Some fn,uu____51554) ->
          let uu____51576 = lowercase_module_name fn  in
          FStar_Pervasives_Native.Some uu____51576
      | FStar_Pervasives_Native.Some
          (uu____51579,FStar_Pervasives_Native.Some fn) ->
          let uu____51602 = lowercase_module_name fn  in
          FStar_Pervasives_Native.Some uu____51602
      | uu____51605 -> FStar_Pervasives_Native.None
  
let (interface_of :
  files_for_module_name ->
    module_name -> file_name FStar_Pervasives_Native.option)
  =
  fun file_system_map  ->
    fun key  ->
      let uu____51638 = FStar_Util.smap_try_find file_system_map key  in
      match uu____51638 with
      | FStar_Pervasives_Native.Some
          (FStar_Pervasives_Native.Some iface,uu____51665) ->
          FStar_Pervasives_Native.Some iface
      | uu____51688 -> FStar_Pervasives_Native.None
  
let (implementation_of :
  files_for_module_name ->
    module_name -> file_name FStar_Pervasives_Native.option)
  =
  fun file_system_map  ->
    fun key  ->
      let uu____51721 = FStar_Util.smap_try_find file_system_map key  in
      match uu____51721 with
      | FStar_Pervasives_Native.Some
          (uu____51747,FStar_Pervasives_Native.Some impl) ->
          FStar_Pervasives_Native.Some impl
      | uu____51771 -> FStar_Pervasives_Native.None
  
let (has_interface : files_for_module_name -> module_name -> Prims.bool) =
  fun file_system_map  ->
    fun key  ->
      let uu____51800 = interface_of file_system_map key  in
      FStar_Option.isSome uu____51800
  
let (has_implementation : files_for_module_name -> module_name -> Prims.bool)
  =
  fun file_system_map  ->
    fun key  ->
      let uu____51820 = implementation_of file_system_map key  in
      FStar_Option.isSome uu____51820
  
let (cache_file_name_internal : Prims.string -> (Prims.string * Prims.bool))
  =
  fun fn  ->
    let cache_fn =
      let uu____51847 =
        let uu____51849 = FStar_Options.lax ()  in
        if uu____51849 then ".checked.lax" else ".checked"  in
      FStar_String.op_Hat fn uu____51847  in
    let uu____51857 =
      let uu____51861 = FStar_All.pipe_right cache_fn FStar_Util.basename  in
      FStar_Options.find_file uu____51861  in
    match uu____51857 with
    | FStar_Pervasives_Native.Some path -> (path, true)
    | FStar_Pervasives_Native.None  ->
        let mname = FStar_All.pipe_right fn module_name_of_file  in
        let uu____51882 =
          FStar_All.pipe_right mname FStar_Options.should_be_already_cached
           in
        if uu____51882
        then
          let uu____51893 =
            let uu____51899 =
              FStar_Util.format1
                "Expected %s to be already checked but could not find it"
                mname
               in
            (FStar_Errors.Error_AlreadyCachedAssertionFailure, uu____51899)
             in
          FStar_Errors.raise_err uu____51893
        else
          (let uu____51911 = FStar_Options.prepend_cache_dir cache_fn  in
           (uu____51911, false))
  
let (cache_file_name : Prims.string -> Prims.string) =
  fun fn  ->
    let uu____51925 = FStar_All.pipe_right fn cache_file_name_internal  in
    FStar_All.pipe_right uu____51925 FStar_Pervasives_Native.fst
  
let (parsing_data_of : deps -> Prims.string -> parsing_data) =
  fun deps  ->
    fun fn  ->
      let uu____51961 = FStar_Util.smap_try_find deps.parse_results fn  in
      FStar_All.pipe_right uu____51961 FStar_Util.must
  
let (file_of_dep_aux :
  Prims.bool ->
    files_for_module_name -> file_name Prims.list -> dependence -> file_name)
  =
  fun use_checked_file  ->
    fun file_system_map  ->
      fun all_cmd_line_files  ->
        fun d  ->
          let cmd_line_has_impl key =
            FStar_All.pipe_right all_cmd_line_files
              (FStar_Util.for_some
                 (fun fn  ->
                    (is_implementation fn) &&
                      (let uu____52015 = lowercase_module_name fn  in
                       key = uu____52015)))
             in
          let maybe_use_cache_of f =
            if use_checked_file then cache_file_name f else f  in
          match d with
          | UseInterface key ->
              let uu____52034 = interface_of file_system_map key  in
              (match uu____52034 with
               | FStar_Pervasives_Native.None  ->
                   let uu____52041 =
                     let uu____52047 =
                       FStar_Util.format1
                         "Expected an interface for module %s, but couldn't find one"
                         key
                        in
                     (FStar_Errors.Fatal_MissingInterface, uu____52047)  in
                   FStar_Errors.raise_err uu____52041
               | FStar_Pervasives_Native.Some f -> f)
          | PreferInterface key when has_interface file_system_map key ->
              let uu____52057 =
                (cmd_line_has_impl key) &&
                  (let uu____52060 = FStar_Options.dep ()  in
                   FStar_Option.isNone uu____52060)
                 in
              if uu____52057
              then
                let uu____52067 = FStar_Options.expose_interfaces ()  in
                (if uu____52067
                 then
                   let uu____52071 =
                     let uu____52073 = implementation_of file_system_map key
                        in
                     FStar_Option.get uu____52073  in
                   maybe_use_cache_of uu____52071
                 else
                   (let uu____52080 =
                      let uu____52086 =
                        let uu____52088 =
                          let uu____52090 =
                            implementation_of file_system_map key  in
                          FStar_Option.get uu____52090  in
                        let uu____52095 =
                          let uu____52097 = interface_of file_system_map key
                             in
                          FStar_Option.get uu____52097  in
                        FStar_Util.format3
                          "You may have a cyclic dependence on module %s: use --dep full to confirm. Alternatively, invoking fstar with %s on the command line breaks the abstraction imposed by its interface %s; if you really want this behavior add the option '--expose_interfaces'"
                          key uu____52088 uu____52095
                         in
                      (FStar_Errors.Fatal_MissingExposeInterfacesOption,
                        uu____52086)
                       in
                    FStar_Errors.raise_err uu____52080))
              else
                (let uu____52107 =
                   let uu____52109 = interface_of file_system_map key  in
                   FStar_Option.get uu____52109  in
                 maybe_use_cache_of uu____52107)
          | PreferInterface key ->
              let uu____52116 = implementation_of file_system_map key  in
              (match uu____52116 with
               | FStar_Pervasives_Native.None  ->
                   let uu____52122 =
                     let uu____52128 =
                       FStar_Util.format1
                         "Expected an implementation of module %s, but couldn't find one"
                         key
                        in
                     (FStar_Errors.Fatal_MissingImplementation, uu____52128)
                      in
                   FStar_Errors.raise_err uu____52122
               | FStar_Pervasives_Native.Some f -> maybe_use_cache_of f)
          | UseImplementation key ->
              let uu____52138 = implementation_of file_system_map key  in
              (match uu____52138 with
               | FStar_Pervasives_Native.None  ->
                   let uu____52144 =
                     let uu____52150 =
                       FStar_Util.format1
                         "Expected an implementation of module %s, but couldn't find one"
                         key
                        in
                     (FStar_Errors.Fatal_MissingImplementation, uu____52150)
                      in
                   FStar_Errors.raise_err uu____52144
               | FStar_Pervasives_Native.Some f -> maybe_use_cache_of f)
          | FriendImplementation key ->
              let uu____52160 = implementation_of file_system_map key  in
              (match uu____52160 with
               | FStar_Pervasives_Native.None  ->
                   let uu____52166 =
                     let uu____52172 =
                       FStar_Util.format1
                         "Expected an implementation of module %s, but couldn't find one"
                         key
                        in
                     (FStar_Errors.Fatal_MissingImplementation, uu____52172)
                      in
                   FStar_Errors.raise_err uu____52166
               | FStar_Pervasives_Native.Some f -> maybe_use_cache_of f)
  
let (file_of_dep :
  files_for_module_name -> file_name Prims.list -> dependence -> file_name) =
  file_of_dep_aux false 
let (dependences_of :
  files_for_module_name ->
    dependence_graph ->
      file_name Prims.list -> file_name -> file_name Prims.list)
  =
  fun file_system_map  ->
    fun deps  ->
      fun all_cmd_line_files  ->
        fun fn  ->
          let uu____52233 = deps_try_find deps fn  in
          match uu____52233 with
          | FStar_Pervasives_Native.None  -> empty_dependences ()
          | FStar_Pervasives_Native.Some
              { edges = deps1; color = uu____52241;_} ->
              FStar_List.map (file_of_dep file_system_map all_cmd_line_files)
                deps1
  
let (print_graph : dependence_graph -> unit) =
  fun graph  ->
    FStar_Util.print_endline
      "A DOT-format graph has been dumped in the current directory as dep.graph";
    FStar_Util.print_endline
      "With GraphViz installed, try: fdp -Tpng -odep.png dep.graph";
    FStar_Util.print_endline
      "Hint: cat dep.graph | grep -v _ | grep -v prims";
    (let uu____52255 =
       let uu____52257 =
         let uu____52259 =
           let uu____52261 =
             let uu____52265 =
               let uu____52269 = deps_keys graph  in
               FStar_List.unique uu____52269  in
             FStar_List.collect
               (fun k  ->
                  let deps =
                    let uu____52283 =
                      let uu____52284 = deps_try_find graph k  in
                      FStar_Util.must uu____52284  in
                    uu____52283.edges  in
                  let r s = FStar_Util.replace_char s 46 95  in
                  let print7 dep1 =
                    let uu____52305 =
                      let uu____52307 = lowercase_module_name k  in
                      r uu____52307  in
                    FStar_Util.format2 "  \"%s\" -> \"%s\"" uu____52305
                      (r (module_name_of_dep dep1))
                     in
                  FStar_List.map print7 deps) uu____52265
              in
           FStar_String.concat "\n" uu____52261  in
         FStar_String.op_Hat uu____52259 "\n}\n"  in
       FStar_String.op_Hat "digraph {\n" uu____52257  in
     FStar_Util.write_file "dep.graph" uu____52255)
  
let (build_inclusion_candidates_list :
  unit -> (Prims.string * Prims.string) Prims.list) =
  fun uu____52328  ->
    let include_directories = FStar_Options.include_path ()  in
    let include_directories1 =
      FStar_List.map FStar_Util.normalize_file_path include_directories  in
    let include_directories2 = FStar_List.unique include_directories1  in
    let cwd =
      let uu____52354 = FStar_Util.getcwd ()  in
      FStar_Util.normalize_file_path uu____52354  in
    FStar_List.concatMap
      (fun d  ->
         if FStar_Util.is_directory d
         then
           let files = FStar_Util.readdir d  in
           FStar_List.filter_map
             (fun f  ->
                let f1 = FStar_Util.basename f  in
                let uu____52394 = check_and_strip_suffix f1  in
                FStar_All.pipe_right uu____52394
                  (FStar_Util.map_option
                     (fun longname  ->
                        let full_path =
                          if d = cwd then f1 else FStar_Util.join_paths d f1
                           in
                        (longname, full_path)))) files
         else
           (let uu____52431 =
              let uu____52437 =
                FStar_Util.format1 "not a valid include directory: %s\n" d
                 in
              (FStar_Errors.Fatal_NotValidIncludeDirectory, uu____52437)  in
            FStar_Errors.raise_err uu____52431)) include_directories2
  
let (build_map : Prims.string Prims.list -> files_for_module_name) =
  fun filenames  ->
    let map1 = FStar_Util.smap_create (Prims.parse_int "41")  in
    let add_entry key full_path =
      let uu____52500 = FStar_Util.smap_try_find map1 key  in
      match uu____52500 with
      | FStar_Pervasives_Native.Some (intf,impl) ->
          let uu____52547 = is_interface full_path  in
          if uu____52547
          then
            FStar_Util.smap_add map1 key
              ((FStar_Pervasives_Native.Some full_path), impl)
          else
            FStar_Util.smap_add map1 key
              (intf, (FStar_Pervasives_Native.Some full_path))
      | FStar_Pervasives_Native.None  ->
          let uu____52596 = is_interface full_path  in
          if uu____52596
          then
            FStar_Util.smap_add map1 key
              ((FStar_Pervasives_Native.Some full_path),
                FStar_Pervasives_Native.None)
          else
            FStar_Util.smap_add map1 key
              (FStar_Pervasives_Native.None,
                (FStar_Pervasives_Native.Some full_path))
       in
    (let uu____52638 = build_inclusion_candidates_list ()  in
     FStar_List.iter
       (fun uu____52656  ->
          match uu____52656 with
          | (longname,full_path) ->
              add_entry (FStar_String.lowercase longname) full_path)
       uu____52638);
    FStar_List.iter
      (fun f  ->
         let uu____52675 = lowercase_module_name f  in
         add_entry uu____52675 f) filenames;
    map1
  
let (enter_namespace :
  files_for_module_name ->
    files_for_module_name -> Prims.string -> Prims.bool)
  =
  fun original_map  ->
    fun working_map  ->
      fun prefix1  ->
        let found = FStar_Util.mk_ref false  in
        let prefix2 = FStar_String.op_Hat prefix1 "."  in
        (let uu____52707 =
           let uu____52711 = FStar_Util.smap_keys original_map  in
           FStar_List.unique uu____52711  in
         FStar_List.iter
           (fun k  ->
              if FStar_Util.starts_with k prefix2
              then
                let suffix =
                  FStar_String.substring k (FStar_String.length prefix2)
                    ((FStar_String.length k) - (FStar_String.length prefix2))
                   in
                let filename =
                  let uu____52747 = FStar_Util.smap_try_find original_map k
                     in
                  FStar_Util.must uu____52747  in
                (FStar_Util.smap_add working_map suffix filename;
                 FStar_ST.op_Colon_Equals found true)
              else ()) uu____52707);
        FStar_ST.op_Bang found
  
let (string_of_lid : FStar_Ident.lident -> Prims.bool -> Prims.string) =
  fun l  ->
    fun last1  ->
      let suffix =
        if last1 then [(l.FStar_Ident.ident).FStar_Ident.idText] else []  in
      let names =
        let uu____52911 =
          FStar_List.map (fun x  -> x.FStar_Ident.idText) l.FStar_Ident.ns
           in
        FStar_List.append uu____52911 suffix  in
      FStar_String.concat "." names
  
let (lowercase_join_longident :
  FStar_Ident.lident -> Prims.bool -> Prims.string) =
  fun l  ->
    fun last1  ->
      let uu____52934 = string_of_lid l last1  in
      FStar_String.lowercase uu____52934
  
let (namespace_of_lid : FStar_Ident.lident -> Prims.string) =
  fun l  ->
    let uu____52943 = FStar_List.map FStar_Ident.text_of_id l.FStar_Ident.ns
       in
    FStar_String.concat "_" uu____52943
  
let (check_module_declaration_against_filename :
  FStar_Ident.lident -> Prims.string -> unit) =
  fun lid  ->
    fun filename  ->
      let k' = lowercase_join_longident lid true  in
      let uu____52965 =
        let uu____52967 =
          let uu____52969 =
            let uu____52971 =
              let uu____52975 = FStar_Util.basename filename  in
              check_and_strip_suffix uu____52975  in
            FStar_Util.must uu____52971  in
          FStar_String.lowercase uu____52969  in
        uu____52967 <> k'  in
      if uu____52965
      then
        let uu____52980 = FStar_Ident.range_of_lid lid  in
        let uu____52981 =
          let uu____52987 =
            let uu____52989 = string_of_lid lid true  in
            FStar_Util.format2
              "The module declaration \"module %s\" found in file %s does not match its filename. Dependencies will be incorrect and the module will not be verified.\n"
              uu____52989 filename
             in
          (FStar_Errors.Error_ModuleFileNameMismatch, uu____52987)  in
        FStar_Errors.log_issue uu____52980 uu____52981
      else ()
  
exception Exit 
let (uu___is_Exit : Prims.exn -> Prims.bool) =
  fun projectee  ->
    match projectee with | Exit  -> true | uu____53005 -> false
  
let (hard_coded_dependencies :
  Prims.string -> (FStar_Ident.lident * open_kind) Prims.list) =
  fun full_filename  ->
    let filename = FStar_Util.basename full_filename  in
    let corelibs =
      let uu____53027 = FStar_Options.prims_basename ()  in
      let uu____53029 =
        let uu____53033 = FStar_Options.pervasives_basename ()  in
        let uu____53035 =
          let uu____53039 = FStar_Options.pervasives_native_basename ()  in
          [uu____53039]  in
        uu____53033 :: uu____53035  in
      uu____53027 :: uu____53029  in
    if FStar_List.mem filename corelibs
    then []
    else
      (let implicit_deps =
         [(FStar_Parser_Const.fstar_ns_lid, Open_namespace);
         (FStar_Parser_Const.prims_lid, Open_module);
         (FStar_Parser_Const.pervasives_lid, Open_module)]  in
       let uu____53082 =
         let uu____53085 = lowercase_module_name full_filename  in
         namespace_of_module uu____53085  in
       match uu____53082 with
       | FStar_Pervasives_Native.None  -> implicit_deps
       | FStar_Pervasives_Native.Some ns ->
           FStar_List.append implicit_deps [(ns, Open_namespace)])
  
let (dep_subsumed_by : dependence -> dependence -> Prims.bool) =
  fun d  ->
    fun d'  ->
      match (d, d') with
      | (PreferInterface l',FriendImplementation l) -> l = l'
      | uu____53124 -> d = d'
  
let (collect_one :
  files_for_module_name ->
    Prims.string ->
      (Prims.string -> parsing_data FStar_Pervasives_Native.option) ->
        parsing_data)
  =
  fun original_map  ->
    fun filename  ->
      fun get_parsing_data_from_cache  ->
        let data_from_cache =
          FStar_All.pipe_right filename get_parsing_data_from_cache  in
        let uu____53164 =
          FStar_All.pipe_right data_from_cache FStar_Util.is_some  in
        if uu____53164
        then FStar_All.pipe_right data_from_cache FStar_Util.must
        else
          (let deps = FStar_Util.mk_ref []  in
           let mo_roots = FStar_Util.mk_ref []  in
           let has_inline_for_extraction = FStar_Util.mk_ref false  in
           let set_interface_inlining uu____53199 =
             let uu____53200 = is_interface filename  in
             if uu____53200
             then FStar_ST.op_Colon_Equals has_inline_for_extraction true
             else ()  in
           let add_dep deps1 d =
             let uu____53407 =
               let uu____53409 =
                 let uu____53411 = FStar_ST.op_Bang deps1  in
                 FStar_List.existsML (dep_subsumed_by d) uu____53411  in
               Prims.op_Negation uu____53409  in
             if uu____53407
             then
               let uu____53480 =
                 let uu____53483 = FStar_ST.op_Bang deps1  in d ::
                   uu____53483
                  in
               FStar_ST.op_Colon_Equals deps1 uu____53480
             else ()  in
           let working_map = FStar_Util.smap_copy original_map  in
           let dep_edge module_name = PreferInterface module_name  in
           let add_dependence_edge original_or_working_map lid =
             let key = lowercase_join_longident lid true  in
             let uu____53664 =
               resolve_module_name original_or_working_map key  in
             match uu____53664 with
             | FStar_Pervasives_Native.Some module_name ->
                 (add_dep deps (dep_edge module_name);
                  (let uu____53707 =
                     (has_interface original_or_working_map module_name) &&
                       (has_implementation original_or_working_map
                          module_name)
                      in
                   if uu____53707
                   then add_dep mo_roots (UseImplementation module_name)
                   else ());
                  true)
             | uu____53746 -> false  in
           let record_open_module let_open lid =
             let uu____53765 =
               (let_open && (add_dependence_edge working_map lid)) ||
                 ((Prims.op_Negation let_open) &&
                    (add_dependence_edge original_map lid))
                in
             if uu____53765
             then true
             else
               (if let_open
                then
                  (let uu____53774 = FStar_Ident.range_of_lid lid  in
                   let uu____53775 =
                     let uu____53781 =
                       let uu____53783 = string_of_lid lid true  in
                       FStar_Util.format1 "Module not found: %s" uu____53783
                        in
                     (FStar_Errors.Warning_ModuleOrFileNotFoundWarning,
                       uu____53781)
                      in
                   FStar_Errors.log_issue uu____53774 uu____53775)
                else ();
                false)
              in
           let record_open_namespace lid =
             let key = lowercase_join_longident lid true  in
             let r = enter_namespace original_map working_map key  in
             if Prims.op_Negation r
             then
               let uu____53803 = FStar_Ident.range_of_lid lid  in
               let uu____53804 =
                 let uu____53810 =
                   let uu____53812 = string_of_lid lid true  in
                   FStar_Util.format1
                     "No modules in namespace %s and no file with that name either"
                     uu____53812
                    in
                 (FStar_Errors.Warning_ModuleOrFileNotFoundWarning,
                   uu____53810)
                  in
               FStar_Errors.log_issue uu____53803 uu____53804
             else ()  in
           let record_open let_open lid =
             let uu____53832 = record_open_module let_open lid  in
             if uu____53832
             then ()
             else
               if Prims.op_Negation let_open
               then record_open_namespace lid
               else ()
              in
           let record_open_module_or_namespace uu____53849 =
             match uu____53849 with
             | (lid,kind) ->
                 (match kind with
                  | Open_namespace  -> record_open_namespace lid
                  | Open_module  ->
                      let uu____53856 = record_open_module false lid  in ())
              in
           let record_module_alias ident lid =
             let key =
               let uu____53873 = FStar_Ident.text_of_id ident  in
               FStar_String.lowercase uu____53873  in
             let alias = lowercase_join_longident lid true  in
             let uu____53878 = FStar_Util.smap_try_find original_map alias
                in
             match uu____53878 with
             | FStar_Pervasives_Native.Some deps_of_aliased_module ->
                 (FStar_Util.smap_add working_map key deps_of_aliased_module;
                  true)
             | FStar_Pervasives_Native.None  ->
                 ((let uu____53946 = FStar_Ident.range_of_lid lid  in
                   let uu____53947 =
                     let uu____53953 =
                       FStar_Util.format1
                         "module not found in search path: %s\n" alias
                        in
                     (FStar_Errors.Warning_ModuleOrFileNotFoundWarning,
                       uu____53953)
                      in
                   FStar_Errors.log_issue uu____53946 uu____53947);
                  false)
              in
           let add_dep_on_module module_name =
             let uu____53964 = add_dependence_edge working_map module_name
                in
             if uu____53964
             then ()
             else
               (let uu____53969 = FStar_Options.debug_any ()  in
                if uu____53969
                then
                  let uu____53972 = FStar_Ident.range_of_lid module_name  in
                  let uu____53973 =
                    let uu____53979 =
                      let uu____53981 = FStar_Ident.string_of_lid module_name
                         in
                      FStar_Util.format1 "Unbound module reference %s"
                        uu____53981
                       in
                    (FStar_Errors.Warning_UnboundModuleReference,
                      uu____53979)
                     in
                  FStar_Errors.log_issue uu____53972 uu____53973
                else ())
              in
           let record_lid lid =
             match lid.FStar_Ident.ns with
             | [] -> ()
             | uu____53993 ->
                 let module_name = FStar_Ident.lid_of_ids lid.FStar_Ident.ns
                    in
                 add_dep_on_module module_name
              in
           let auto_open = hard_coded_dependencies filename  in
           FStar_List.iter record_open_module_or_namespace auto_open;
           (let num_of_toplevelmods = FStar_Util.mk_ref (Prims.parse_int "0")
               in
            let rec collect_module uu___426_54121 =
              match uu___426_54121 with
              | FStar_Parser_AST.Module (lid,decls) ->
                  (check_module_declaration_against_filename lid filename;
                   if
                     (FStar_List.length lid.FStar_Ident.ns) >
                       (Prims.parse_int "0")
                   then
                     (let uu____54132 =
                        let uu____54134 = namespace_of_lid lid  in
                        enter_namespace original_map working_map uu____54134
                         in
                      ())
                   else ();
                   collect_decls decls)
              | FStar_Parser_AST.Interface (lid,decls,uu____54140) ->
                  (check_module_declaration_against_filename lid filename;
                   if
                     (FStar_List.length lid.FStar_Ident.ns) >
                       (Prims.parse_int "0")
                   then
                     (let uu____54151 =
                        let uu____54153 = namespace_of_lid lid  in
                        enter_namespace original_map working_map uu____54153
                         in
                      ())
                   else ();
                   collect_decls decls)
            
            and collect_decls decls =
              FStar_List.iter
                (fun x  ->
                   collect_decl x.FStar_Parser_AST.d;
                   FStar_List.iter collect_term x.FStar_Parser_AST.attrs;
                   if
                     FStar_List.contains
                       FStar_Parser_AST.Inline_for_extraction
                       x.FStar_Parser_AST.quals
                   then set_interface_inlining ()
                   else ()) decls
            
            and collect_decl d =
              match d with
              | FStar_Parser_AST.Include lid -> record_open false lid
              | FStar_Parser_AST.Open lid -> record_open false lid
              | FStar_Parser_AST.Friend lid ->
                  let uu____54175 =
                    let uu____54176 = lowercase_join_longident lid true  in
                    FriendImplementation uu____54176  in
                  add_dep deps uu____54175
              | FStar_Parser_AST.ModuleAbbrev (ident,lid) ->
                  let uu____54214 = record_module_alias ident lid  in
                  if uu____54214
                  then
                    let uu____54217 =
                      let uu____54218 = lowercase_join_longident lid true  in
                      dep_edge uu____54218  in
                    add_dep deps uu____54217
                  else ()
              | FStar_Parser_AST.TopLevelLet (uu____54256,patterms) ->
                  FStar_List.iter
                    (fun uu____54278  ->
                       match uu____54278 with
                       | (pat,t) -> (collect_pattern pat; collect_term t))
                    patterms
              | FStar_Parser_AST.Main t -> collect_term t
              | FStar_Parser_AST.Splice (uu____54287,t) -> collect_term t
              | FStar_Parser_AST.Assume (uu____54293,t) -> collect_term t
              | FStar_Parser_AST.SubEffect
                  { FStar_Parser_AST.msource = uu____54295;
                    FStar_Parser_AST.mdest = uu____54296;
                    FStar_Parser_AST.lift_op =
                      FStar_Parser_AST.NonReifiableLift t;_}
                  -> collect_term t
              | FStar_Parser_AST.SubEffect
                  { FStar_Parser_AST.msource = uu____54298;
                    FStar_Parser_AST.mdest = uu____54299;
                    FStar_Parser_AST.lift_op = FStar_Parser_AST.LiftForFree t;_}
                  -> collect_term t
              | FStar_Parser_AST.Val (uu____54301,t) -> collect_term t
              | FStar_Parser_AST.SubEffect
                  { FStar_Parser_AST.msource = uu____54303;
                    FStar_Parser_AST.mdest = uu____54304;
                    FStar_Parser_AST.lift_op = FStar_Parser_AST.ReifiableLift
                      (t0,t1);_}
                  -> (collect_term t0; collect_term t1)
              | FStar_Parser_AST.Tycon (uu____54308,tc,ts) ->
                  (if tc
                   then record_lid FStar_Parser_Const.mk_class_lid
                   else ();
                   (let ts1 =
                      FStar_List.map
                        (fun uu____54347  ->
                           match uu____54347 with | (x,docnik) -> x) ts
                       in
                    FStar_List.iter collect_tycon ts1))
              | FStar_Parser_AST.Exception (uu____54360,t) ->
                  FStar_Util.iter_opt t collect_term
              | FStar_Parser_AST.NewEffect ed -> collect_effect_decl ed
              | FStar_Parser_AST.Fsdoc uu____54367 -> ()
              | FStar_Parser_AST.Pragma uu____54368 -> ()
              | FStar_Parser_AST.TopLevelModule lid ->
                  (FStar_Util.incr num_of_toplevelmods;
                   (let uu____54404 =
                      let uu____54406 = FStar_ST.op_Bang num_of_toplevelmods
                         in
                      uu____54406 > (Prims.parse_int "1")  in
                    if uu____54404
                    then
                      let uu____54453 =
                        let uu____54459 =
                          let uu____54461 = string_of_lid lid true  in
                          FStar_Util.format1
                            "Automatic dependency analysis demands one module per file (module %s not supported)"
                            uu____54461
                           in
                        (FStar_Errors.Fatal_OneModulePerFile, uu____54459)
                         in
                      let uu____54466 = FStar_Ident.range_of_lid lid  in
                      FStar_Errors.raise_error uu____54453 uu____54466
                    else ()))
            
            and collect_tycon uu___427_54469 =
              match uu___427_54469 with
              | FStar_Parser_AST.TyconAbstract (uu____54470,binders,k) ->
                  (collect_binders binders;
                   FStar_Util.iter_opt k collect_term)
              | FStar_Parser_AST.TyconAbbrev (uu____54482,binders,k,t) ->
                  (collect_binders binders;
                   FStar_Util.iter_opt k collect_term;
                   collect_term t)
              | FStar_Parser_AST.TyconRecord
                  (uu____54496,binders,k,identterms) ->
                  (collect_binders binders;
                   FStar_Util.iter_opt k collect_term;
                   FStar_List.iter
                     (fun uu____54542  ->
                        match uu____54542 with
                        | (uu____54551,t,uu____54553) -> collect_term t)
                     identterms)
              | FStar_Parser_AST.TyconVariant
                  (uu____54558,binders,k,identterms) ->
                  (collect_binders binders;
                   FStar_Util.iter_opt k collect_term;
                   FStar_List.iter
                     (fun uu____54620  ->
                        match uu____54620 with
                        | (uu____54634,t,uu____54636,uu____54637) ->
                            FStar_Util.iter_opt t collect_term) identterms)
            
            and collect_effect_decl uu___428_54648 =
              match uu___428_54648 with
              | FStar_Parser_AST.DefineEffect (uu____54649,binders,t,decls)
                  ->
                  (collect_binders binders;
                   collect_term t;
                   collect_decls decls)
              | FStar_Parser_AST.RedefineEffect (uu____54663,binders,t) ->
                  (collect_binders binders; collect_term t)
            
            and collect_binders binders =
              FStar_List.iter collect_binder binders
            
            and collect_binder b =
              collect_aqual b.FStar_Parser_AST.aqual;
              (match b with
               | {
                   FStar_Parser_AST.b = FStar_Parser_AST.Annotated
                     (uu____54676,t);
                   FStar_Parser_AST.brange = uu____54678;
                   FStar_Parser_AST.blevel = uu____54679;
                   FStar_Parser_AST.aqual = uu____54680;_} -> collect_term t
               | {
                   FStar_Parser_AST.b = FStar_Parser_AST.TAnnotated
                     (uu____54683,t);
                   FStar_Parser_AST.brange = uu____54685;
                   FStar_Parser_AST.blevel = uu____54686;
                   FStar_Parser_AST.aqual = uu____54687;_} -> collect_term t
               | { FStar_Parser_AST.b = FStar_Parser_AST.NoName t;
                   FStar_Parser_AST.brange = uu____54691;
                   FStar_Parser_AST.blevel = uu____54692;
                   FStar_Parser_AST.aqual = uu____54693;_} -> collect_term t
               | uu____54696 -> ())
            
            and collect_aqual uu___429_54697 =
              match uu___429_54697 with
              | FStar_Pervasives_Native.Some (FStar_Parser_AST.Meta t) ->
                  collect_term t
              | uu____54701 -> ()
            
            and collect_term t = collect_term' t.FStar_Parser_AST.tm
            
            and collect_constant uu___430_54705 =
              match uu___430_54705 with
              | FStar_Const.Const_int
                  (uu____54706,FStar_Pervasives_Native.Some
                   (signedness,width))
                  ->
                  let u =
                    match signedness with
                    | FStar_Const.Unsigned  -> "u"
                    | FStar_Const.Signed  -> ""  in
                  let w =
                    match width with
                    | FStar_Const.Int8  -> "8"
                    | FStar_Const.Int16  -> "16"
                    | FStar_Const.Int32  -> "32"
                    | FStar_Const.Int64  -> "64"  in
                  let uu____54733 =
                    let uu____54734 = FStar_Util.format2 "fstar.%sint%s" u w
                       in
                    dep_edge uu____54734  in
                  add_dep deps uu____54733
              | FStar_Const.Const_char uu____54770 ->
                  add_dep deps (dep_edge "fstar.char")
              | FStar_Const.Const_float uu____54806 ->
                  add_dep deps (dep_edge "fstar.float")
              | uu____54841 -> ()
            
            and collect_term' uu___433_54842 =
              match uu___433_54842 with
              | FStar_Parser_AST.Wild  -> ()
              | FStar_Parser_AST.Const c -> collect_constant c
              | FStar_Parser_AST.Op (s,ts) ->
                  ((let uu____54851 =
                      let uu____54853 = FStar_Ident.text_of_id s  in
                      uu____54853 = "@"  in
                    if uu____54851
                    then
                      let uu____54858 =
                        let uu____54859 =
                          let uu____54860 =
                            FStar_Ident.path_of_text
                              "FStar.List.Tot.Base.append"
                             in
                          FStar_Ident.lid_of_path uu____54860
                            FStar_Range.dummyRange
                           in
                        FStar_Parser_AST.Name uu____54859  in
                      collect_term' uu____54858
                    else ());
                   FStar_List.iter collect_term ts)
              | FStar_Parser_AST.Tvar uu____54864 -> ()
              | FStar_Parser_AST.Uvar uu____54865 -> ()
              | FStar_Parser_AST.Var lid -> record_lid lid
              | FStar_Parser_AST.Projector (lid,uu____54868) ->
                  record_lid lid
              | FStar_Parser_AST.Discrim lid -> record_lid lid
              | FStar_Parser_AST.Name lid -> record_lid lid
              | FStar_Parser_AST.Construct (lid,termimps) ->
                  (record_lid lid;
                   FStar_List.iter
                     (fun uu____54893  ->
                        match uu____54893 with
                        | (t,uu____54899) -> collect_term t) termimps)
              | FStar_Parser_AST.Abs (pats,t) ->
                  (collect_patterns pats; collect_term t)
              | FStar_Parser_AST.App (t1,t2,uu____54909) ->
                  (collect_term t1; collect_term t2)
              | FStar_Parser_AST.Let (uu____54911,patterms,t) ->
                  (FStar_List.iter
                     (fun uu____54961  ->
                        match uu____54961 with
                        | (attrs_opt,(pat,t1)) ->
                            ((let uu____54990 =
                                FStar_Util.map_opt attrs_opt
                                  (FStar_List.iter collect_term)
                                 in
                              ());
                             collect_pattern pat;
                             collect_term t1)) patterms;
                   collect_term t)
              | FStar_Parser_AST.LetOpen (lid,t) ->
                  (record_open true lid; collect_term t)
              | FStar_Parser_AST.Bind (uu____55000,t1,t2) ->
                  (collect_term t1; collect_term t2)
              | FStar_Parser_AST.Seq (t1,t2) ->
                  (collect_term t1; collect_term t2)
              | FStar_Parser_AST.If (t1,t2,t3) ->
                  (collect_term t1; collect_term t2; collect_term t3)
              | FStar_Parser_AST.Match (t,bs) ->
                  (collect_term t; collect_branches bs)
              | FStar_Parser_AST.TryWith (t,bs) ->
                  (collect_term t; collect_branches bs)
              | FStar_Parser_AST.Ascribed
                  (t1,t2,FStar_Pervasives_Native.None ) ->
                  (collect_term t1; collect_term t2)
              | FStar_Parser_AST.Ascribed
                  (t1,t2,FStar_Pervasives_Native.Some tac) ->
                  (collect_term t1; collect_term t2; collect_term tac)
              | FStar_Parser_AST.Record (t,idterms) ->
                  (FStar_Util.iter_opt t collect_term;
                   FStar_List.iter
                     (fun uu____55096  ->
                        match uu____55096 with
                        | (uu____55101,t1) -> collect_term t1) idterms)
              | FStar_Parser_AST.Project (t,uu____55104) -> collect_term t
              | FStar_Parser_AST.Product (binders,t) ->
                  (collect_binders binders; collect_term t)
              | FStar_Parser_AST.Sum (binders,t) ->
                  (FStar_List.iter
                     (fun uu___431_55133  ->
                        match uu___431_55133 with
                        | FStar_Util.Inl b -> collect_binder b
                        | FStar_Util.Inr t1 -> collect_term t1) binders;
                   collect_term t)
              | FStar_Parser_AST.QForall (binders,ts,t) ->
                  (collect_binders binders;
                   FStar_List.iter (FStar_List.iter collect_term) ts;
                   collect_term t)
              | FStar_Parser_AST.QExists (binders,ts,t) ->
                  (collect_binders binders;
                   FStar_List.iter (FStar_List.iter collect_term) ts;
                   collect_term t)
              | FStar_Parser_AST.Refine (binder,t) ->
                  (collect_binder binder; collect_term t)
              | FStar_Parser_AST.NamedTyp (uu____55181,t) -> collect_term t
              | FStar_Parser_AST.Paren t -> collect_term t
              | FStar_Parser_AST.Requires (t,uu____55185) -> collect_term t
              | FStar_Parser_AST.Ensures (t,uu____55193) -> collect_term t
              | FStar_Parser_AST.Labeled (t,uu____55201,uu____55202) ->
                  collect_term t
              | FStar_Parser_AST.Quote (t,uu____55208) -> collect_term t
              | FStar_Parser_AST.Antiquote t -> collect_term t
              | FStar_Parser_AST.VQuote t -> collect_term t
              | FStar_Parser_AST.Attributes cattributes ->
                  FStar_List.iter collect_term cattributes
              | FStar_Parser_AST.CalcProof (rel,init1,steps) ->
                  ((let uu____55222 = FStar_Ident.lid_of_str "FStar.Calc"  in
                    add_dep_on_module uu____55222);
                   collect_term rel;
                   collect_term init1;
                   FStar_List.iter
                     (fun uu___432_55232  ->
                        match uu___432_55232 with
                        | FStar_Parser_AST.CalcStep (rel1,just,next) ->
                            (collect_term rel1;
                             collect_term just;
                             collect_term next)) steps)
            
            and collect_patterns ps = FStar_List.iter collect_pattern ps
            
            and collect_pattern p = collect_pattern' p.FStar_Parser_AST.pat
            
            and collect_pattern' uu___434_55242 =
              match uu___434_55242 with
              | FStar_Parser_AST.PatVar (uu____55243,aqual) ->
                  collect_aqual aqual
              | FStar_Parser_AST.PatTvar (uu____55249,aqual) ->
                  collect_aqual aqual
              | FStar_Parser_AST.PatWild aqual -> collect_aqual aqual
              | FStar_Parser_AST.PatOp uu____55258 -> ()
              | FStar_Parser_AST.PatConst uu____55259 -> ()
              | FStar_Parser_AST.PatApp (p,ps) ->
                  (collect_pattern p; collect_patterns ps)
              | FStar_Parser_AST.PatName uu____55267 -> ()
              | FStar_Parser_AST.PatList ps -> collect_patterns ps
              | FStar_Parser_AST.PatOr ps -> collect_patterns ps
              | FStar_Parser_AST.PatTuple (ps,uu____55275) ->
                  collect_patterns ps
              | FStar_Parser_AST.PatRecord lidpats ->
                  FStar_List.iter
                    (fun uu____55296  ->
                       match uu____55296 with
                       | (uu____55301,p) -> collect_pattern p) lidpats
              | FStar_Parser_AST.PatAscribed
                  (p,(t,FStar_Pervasives_Native.None )) ->
                  (collect_pattern p; collect_term t)
              | FStar_Parser_AST.PatAscribed
                  (p,(t,FStar_Pervasives_Native.Some tac)) ->
                  (collect_pattern p; collect_term t; collect_term tac)
            
            and collect_branches bs = FStar_List.iter collect_branch bs
            
            and collect_branch uu____55346 =
              match uu____55346 with
              | (pat,t1,t2) ->
                  (collect_pattern pat;
                   FStar_Util.iter_opt t1 collect_term;
                   collect_term t2)
             in
            let uu____55364 = FStar_Parser_Driver.parse_file filename  in
            match uu____55364 with
            | (ast,uu____55377) ->
                let mname = lowercase_module_name filename  in
                ((let uu____55395 =
                    (is_interface filename) &&
                      (has_implementation original_map mname)
                     in
                  if uu____55395
                  then add_dep mo_roots (UseImplementation mname)
                  else ());
                 collect_module ast;
                 (let uu____55434 = FStar_ST.op_Bang deps  in
                  let uu____55482 = FStar_ST.op_Bang mo_roots  in
                  let uu____55530 =
                    FStar_ST.op_Bang has_inline_for_extraction  in
                  {
                    direct_deps = uu____55434;
                    additional_roots = uu____55482;
                    has_inline_for_extraction = uu____55530
                  }))))
  
let (collect_one_cache :
  (dependence Prims.list * dependence Prims.list * Prims.bool)
    FStar_Util.smap FStar_ST.ref)
  =
  let uu____55602 = FStar_Util.smap_create (Prims.parse_int "0")  in
  FStar_Util.mk_ref uu____55602 
let (set_collect_one_cache :
  (dependence Prims.list * dependence Prims.list * Prims.bool)
    FStar_Util.smap -> unit)
  = fun cache  -> FStar_ST.op_Colon_Equals collect_one_cache cache 
let (dep_graph_copy : dependence_graph -> dependence_graph) =
  fun dep_graph  ->
    let uu____55724 = dep_graph  in
    match uu____55724 with
    | Deps g -> let uu____55728 = FStar_Util.smap_copy g  in Deps uu____55728
  
let (topological_dependences_of :
  files_for_module_name ->
    dependence_graph ->
      Prims.string Prims.list ->
        file_name Prims.list ->
          Prims.bool -> (file_name Prims.list * Prims.bool))
  =
  fun file_system_map  ->
    fun dep_graph  ->
      fun interfaces_needing_inlining  ->
        fun root_files  ->
          fun for_extraction  ->
            let rec all_friend_deps_1 dep_graph1 cycle uu____55873 filename =
              match uu____55873 with
              | (all_friends,all_files) ->
                  let dep_node =
                    let uu____55914 = deps_try_find dep_graph1 filename  in
                    FStar_Util.must uu____55914  in
                  (match dep_node.color with
                   | Gray  ->
                       failwith
                         "Impossible: cycle detected after cycle detection has passed"
                   | Black  -> (all_friends, all_files)
                   | White  ->
                       ((let uu____55945 = FStar_Options.debug_any ()  in
                         if uu____55945
                         then
                           let uu____55948 =
                             let uu____55950 =
                               FStar_List.map dep_to_string dep_node.edges
                                in
                             FStar_String.concat ", " uu____55950  in
                           FStar_Util.print2
                             "Visiting %s: direct deps are %s\n" filename
                             uu____55948
                         else ());
                        deps_add_dep dep_graph1 filename
                          (let uu___1245_55961 = dep_node  in
                           { edges = (uu___1245_55961.edges); color = Gray });
                        (let uu____55962 =
                           let uu____55973 =
                             dependences_of file_system_map dep_graph1
                               root_files filename
                              in
                           all_friend_deps dep_graph1 cycle
                             (all_friends, all_files) uu____55973
                            in
                         match uu____55962 with
                         | (all_friends1,all_files1) ->
                             (deps_add_dep dep_graph1 filename
                                (let uu___1251_56009 = dep_node  in
                                 {
                                   edges = (uu___1251_56009.edges);
                                   color = Black
                                 });
                              (let uu____56011 = FStar_Options.debug_any ()
                                  in
                               if uu____56011
                               then FStar_Util.print1 "Adding %s\n" filename
                               else ());
                              (let uu____56017 =
                                 let uu____56021 =
                                   FStar_List.collect
                                     (fun uu___435_56028  ->
                                        match uu___435_56028 with
                                        | FriendImplementation m -> [m]
                                        | d -> []) dep_node.edges
                                    in
                                 FStar_List.append uu____56021 all_friends1
                                  in
                               (uu____56017, (filename :: all_files1)))))))
            
            and all_friend_deps dep_graph1 cycle all_friends filenames =
              FStar_List.fold_left
                (fun all_friends1  ->
                   fun k  ->
                     all_friend_deps_1 dep_graph1 (k :: cycle) all_friends1 k)
                all_friends filenames
             in
            (let uu____56094 = FStar_Options.debug_any ()  in
             if uu____56094
             then
               FStar_Util.print_string
                 "==============Phase1==================\n"
             else ());
            (let widened = FStar_Util.mk_ref false  in
             let widen_deps friends deps =
               let uu____56123 = deps  in
               match uu____56123 with
               | Deps dg ->
                   let uu____56127 = deps_empty ()  in
                   (match uu____56127 with
                    | Deps dg' ->
                        let widen_one deps1 =
                          FStar_All.pipe_right deps1
                            (FStar_List.map
                               (fun d  ->
                                  match d with
                                  | PreferInterface m when
                                      (FStar_List.contains m friends) &&
                                        (has_implementation file_system_map m)
                                      ->
                                      (FStar_ST.op_Colon_Equals widened true;
                                       FriendImplementation m)
                                  | uu____56199 -> d))
                           in
                        (FStar_Util.smap_fold dg
                           (fun filename  ->
                              fun dep_node  ->
                                fun uu____56207  ->
                                  let uu____56209 =
                                    let uu___1286_56210 = dep_node  in
                                    let uu____56211 =
                                      widen_one dep_node.edges  in
                                    { edges = uu____56211; color = White }
                                     in
                                  FStar_Util.smap_add dg' filename
                                    uu____56209) ();
                         Deps dg'))
                in
             let dep_graph1 =
               let uu____56213 = (FStar_Options.cmi ()) && for_extraction  in
               if uu____56213
               then widen_deps interfaces_needing_inlining dep_graph
               else dep_graph  in
             let uu____56218 =
               all_friend_deps dep_graph1 [] ([], []) root_files  in
             match uu____56218 with
             | (friends,all_files_0) ->
                 ((let uu____56261 = FStar_Options.debug_any ()  in
                   if uu____56261
                   then
                     let uu____56264 =
                       let uu____56266 =
                         FStar_Util.remove_dups (fun x  -> fun y  -> x = y)
                           friends
                          in
                       FStar_String.concat ", " uu____56266  in
                     FStar_Util.print3
                       "Phase1 complete:\n\tall_files = %s\n\tall_friends=%s\n\tinterfaces_with_inlining=%s\n"
                       (FStar_String.concat ", " all_files_0) uu____56264
                       (FStar_String.concat ", " interfaces_needing_inlining)
                   else ());
                  (let dep_graph2 = widen_deps friends dep_graph1  in
                   let uu____56285 =
                     (let uu____56297 = FStar_Options.debug_any ()  in
                      if uu____56297
                      then
                        FStar_Util.print_string
                          "==============Phase2==================\n"
                      else ());
                     all_friend_deps dep_graph2 [] ([], []) root_files  in
                   match uu____56285 with
                   | (uu____56320,all_files) ->
                       ((let uu____56335 = FStar_Options.debug_any ()  in
                         if uu____56335
                         then
                           FStar_Util.print1
                             "Phase2 complete: all_files = %s\n"
                             (FStar_String.concat ", " all_files)
                         else ());
                        (let uu____56342 = FStar_ST.op_Bang widened  in
                         (all_files, uu____56342))))))
  
let (collect :
  Prims.string Prims.list ->
    (Prims.string -> parsing_data FStar_Pervasives_Native.option) ->
      (Prims.string Prims.list * deps))
  =
  fun all_cmd_line_files  ->
    fun get_parsing_data_from_cache  ->
      let all_cmd_line_files1 =
        FStar_All.pipe_right all_cmd_line_files
          (FStar_List.map
             (fun fn  ->
                let uu____56450 = FStar_Options.find_file fn  in
                match uu____56450 with
                | FStar_Pervasives_Native.None  ->
                    let uu____56456 =
                      let uu____56462 =
                        FStar_Util.format1 "File %s could not be found\n" fn
                         in
                      (FStar_Errors.Fatal_ModuleOrFileNotFound, uu____56462)
                       in
                    FStar_Errors.raise_err uu____56456
                | FStar_Pervasives_Native.Some fn1 -> fn1))
         in
      let dep_graph = deps_empty ()  in
      let file_system_map = build_map all_cmd_line_files1  in
      let interfaces_needing_inlining = FStar_Util.mk_ref []  in
      let add_interface_for_inlining l =
        let l1 = lowercase_module_name l  in
        let uu____56492 =
          let uu____56496 = FStar_ST.op_Bang interfaces_needing_inlining  in
          l1 :: uu____56496  in
        FStar_ST.op_Colon_Equals interfaces_needing_inlining uu____56492  in
      let parse_results = FStar_Util.smap_create (Prims.parse_int "40")  in
      let rec discover_one file_name =
        let uu____56607 =
          let uu____56609 = deps_try_find dep_graph file_name  in
          uu____56609 = FStar_Pervasives_Native.None  in
        if uu____56607
        then
          let uu____56615 =
            let uu____56627 =
              let uu____56641 = FStar_ST.op_Bang collect_one_cache  in
              FStar_Util.smap_try_find uu____56641 file_name  in
            match uu____56627 with
            | FStar_Pervasives_Native.Some cached -> cached
            | FStar_Pervasives_Native.None  ->
                let r =
                  collect_one file_system_map file_name
                    get_parsing_data_from_cache
                   in
                ((r.direct_deps), (r.additional_roots),
                  (r.has_inline_for_extraction))
             in
          match uu____56615 with
          | (deps,mo_roots,needs_interface_inlining) ->
              (if needs_interface_inlining
               then add_interface_for_inlining file_name
               else ();
               FStar_Util.smap_add parse_results file_name
                 {
                   direct_deps = deps;
                   additional_roots = mo_roots;
                   has_inline_for_extraction = needs_interface_inlining
                 };
               (let deps1 =
                  let module_name = lowercase_module_name file_name  in
                  let uu____56785 =
                    (is_implementation file_name) &&
                      (has_interface file_system_map module_name)
                     in
                  if uu____56785
                  then FStar_List.append deps [UseInterface module_name]
                  else deps  in
                let dep_node =
                  let uu____56793 = FStar_List.unique deps1  in
                  { edges = uu____56793; color = White }  in
                deps_add_dep dep_graph file_name dep_node;
                (let uu____56795 =
                   FStar_List.map
                     (file_of_dep file_system_map all_cmd_line_files1)
                     (FStar_List.append deps1 mo_roots)
                    in
                 FStar_List.iter discover_one uu____56795)))
        else ()  in
      FStar_List.iter discover_one all_cmd_line_files1;
      (let cycle_detected dep_graph1 cycle filename =
         FStar_Util.print1
           "The cycle contains a subset of the modules in:\n%s \n"
           (FStar_String.concat "\n`used by` " cycle);
         print_graph dep_graph1;
         FStar_Util.print_string "\n";
         (let uu____56835 =
            let uu____56841 =
              FStar_Util.format1 "Recursive dependency on module %s\n"
                filename
               in
            (FStar_Errors.Fatal_CyclicDependence, uu____56841)  in
          FStar_Errors.raise_err uu____56835)
          in
       let full_cycle_detection all_command_line_files =
         let dep_graph1 = dep_graph_copy dep_graph  in
         let rec aux cycle filename =
           let node =
             let uu____56878 = deps_try_find dep_graph1 filename  in
             match uu____56878 with
             | FStar_Pervasives_Native.Some node -> node
             | FStar_Pervasives_Native.None  ->
                 let uu____56882 =
                   FStar_Util.format1 "Failed to find dependences of %s"
                     filename
                    in
                 failwith uu____56882
              in
           let direct_deps =
             FStar_All.pipe_right node.edges
               (FStar_List.collect
                  (fun x  ->
                     match x with
                     | UseInterface f ->
                         let uu____56896 =
                           implementation_of file_system_map f  in
                         (match uu____56896 with
                          | FStar_Pervasives_Native.None  -> [x]
                          | FStar_Pervasives_Native.Some fn when
                              fn = filename -> [x]
                          | uu____56907 -> [x; UseImplementation f])
                     | PreferInterface f ->
                         let uu____56913 =
                           implementation_of file_system_map f  in
                         (match uu____56913 with
                          | FStar_Pervasives_Native.None  -> [x]
                          | FStar_Pervasives_Native.Some fn when
                              fn = filename -> [x]
                          | uu____56924 -> [x; UseImplementation f])
                     | uu____56928 -> [x]))
              in
           match node.color with
           | Gray  -> cycle_detected dep_graph1 cycle filename
           | Black  -> ()
           | White  ->
               (deps_add_dep dep_graph1 filename
                  (let uu___1370_56931 = node  in
                   { edges = direct_deps; color = Gray });
                (let uu____56933 =
                   dependences_of file_system_map dep_graph1
                     all_command_line_files filename
                    in
                 FStar_List.iter (fun k  -> aux (k :: cycle) k) uu____56933);
                deps_add_dep dep_graph1 filename
                  (let uu___1375_56943 = node  in
                   { edges = direct_deps; color = Black }))
            in
         FStar_List.iter (aux []) all_command_line_files  in
       full_cycle_detection all_cmd_line_files1;
       FStar_All.pipe_right all_cmd_line_files1
         (FStar_List.iter
            (fun f  ->
               let m = lowercase_module_name f  in
               FStar_Options.add_verify_module m));
       (let inlining_ifaces = FStar_ST.op_Bang interfaces_needing_inlining
           in
        let uu____57009 =
          let uu____57018 =
            let uu____57020 = FStar_Options.codegen ()  in
            uu____57020 <> FStar_Pervasives_Native.None  in
          topological_dependences_of file_system_map dep_graph
            inlining_ifaces all_cmd_line_files1 uu____57018
           in
        match uu____57009 with
        | (all_files,uu____57033) ->
            ((let uu____57043 = FStar_Options.debug_any ()  in
              if uu____57043
              then
                FStar_Util.print1 "Interfaces needing inlining: %s\n"
                  (FStar_String.concat ", " inlining_ifaces)
              else ());
             (all_files,
               (mk_deps dep_graph file_system_map all_cmd_line_files1
                  all_files inlining_ifaces parse_results)))))
  
let (deps_of : deps -> Prims.string -> Prims.string Prims.list) =
  fun deps  ->
    fun f  ->
      dependences_of deps.file_system_map deps.dep_graph deps.cmd_line_files
        f
  
let (hash_dependences :
  deps ->
    Prims.string ->
      Prims.string ->
        (Prims.string,(Prims.string * Prims.string) Prims.list)
          FStar_Util.either)
  =
  fun deps  ->
    fun fn  ->
      fun cache_file  ->
        let file_system_map = deps.file_system_map  in
        let all_cmd_line_files = deps.cmd_line_files  in
        let deps1 = deps.dep_graph  in
        let fn1 =
          let uu____57113 = FStar_Options.find_file fn  in
          match uu____57113 with
          | FStar_Pervasives_Native.Some fn1 -> fn1
          | uu____57121 -> fn  in
        let digest_of_file1 fn2 =
          (let uu____57135 = FStar_Options.debug_any ()  in
           if uu____57135
           then
             FStar_Util.print2 "%s: contains digest of %s\n" cache_file fn2
           else ());
          FStar_Util.digest_of_file fn2  in
        let module_name = lowercase_module_name fn1  in
        let source_hash = digest_of_file1 fn1  in
        let interface_hash =
          let uu____57154 =
            (is_implementation fn1) &&
              (has_interface file_system_map module_name)
             in
          if uu____57154
          then
            let uu____57165 =
              let uu____57172 =
                let uu____57174 =
                  let uu____57176 = interface_of file_system_map module_name
                     in
                  FStar_Option.get uu____57176  in
                digest_of_file1 uu____57174  in
              ("interface", uu____57172)  in
            [uu____57165]
          else []  in
        let binary_deps =
          let uu____57208 =
            dependences_of file_system_map deps1 all_cmd_line_files fn1  in
          FStar_All.pipe_right uu____57208
            (FStar_List.filter
               (fun fn2  ->
                  let uu____57223 =
                    (is_interface fn2) &&
                      (let uu____57226 = lowercase_module_name fn2  in
                       uu____57226 = module_name)
                     in
                  Prims.op_Negation uu____57223))
           in
        let binary_deps1 =
          FStar_List.sortWith
            (fun fn11  ->
               fun fn2  ->
                 let uu____57242 = lowercase_module_name fn11  in
                 let uu____57244 = lowercase_module_name fn2  in
                 FStar_String.compare uu____57242 uu____57244) binary_deps
           in
        let rec hash_deps out uu___436_57280 =
          match uu___436_57280 with
          | [] ->
              FStar_Util.Inr
                (FStar_List.append (("source", source_hash) ::
                   interface_hash) out)
          | fn2::deps2 ->
              let cache_fn = cache_file_name fn2  in
              let digest =
                if FStar_Util.file_exists cache_fn
                then
                  let uu____57347 = digest_of_file1 fn2  in
                  FStar_Pervasives_Native.Some uu____57347
                else FStar_Pervasives_Native.None  in
              (match digest with
               | FStar_Pervasives_Native.None  ->
                   ((let uu____57368 = FStar_Options.debug_any ()  in
                     if uu____57368
                     then
                       let uu____57371 = FStar_Util.basename cache_fn  in
                       FStar_Util.print2 "%s: missed digest of file %s\n"
                         cache_file uu____57371
                     else ());
                    (let uu____57376 =
                       FStar_Util.format1 "cache file %s does not exist"
                         cache_fn
                        in
                     FStar_Util.Inl uu____57376))
               | FStar_Pervasives_Native.Some dig ->
                   let uu____57391 =
                     let uu____57400 =
                       let uu____57407 = lowercase_module_name fn2  in
                       (uu____57407, dig)  in
                     uu____57400 :: out  in
                   hash_deps uu____57391 deps2)
           in
        hash_deps [] binary_deps1
  
let (print_digest : (Prims.string * Prims.string) Prims.list -> Prims.string)
  =
  fun dig  ->
    let uu____57447 =
      FStar_All.pipe_right dig
        (FStar_List.map
           (fun uu____57473  ->
              match uu____57473 with
              | (m,d) ->
                  let uu____57487 = FStar_Util.base64_encode d  in
                  FStar_Util.format2 "%s:%s" m uu____57487))
       in
    FStar_All.pipe_right uu____57447 (FStar_String.concat "\n")
  
let (print_make : deps -> unit) =
  fun deps  ->
    let file_system_map = deps.file_system_map  in
    let all_cmd_line_files = deps.cmd_line_files  in
    let deps1 = deps.dep_graph  in
    let keys = deps_keys deps1  in
    FStar_All.pipe_right keys
      (FStar_List.iter
         (fun f  ->
            let dep_node =
              let uu____57522 = deps_try_find deps1 f  in
              FStar_All.pipe_right uu____57522 FStar_Option.get  in
            let files =
              FStar_List.map (file_of_dep file_system_map all_cmd_line_files)
                dep_node.edges
               in
            let files1 =
              FStar_List.map (fun s  -> FStar_Util.replace_chars s 32 "\\ ")
                files
               in
            FStar_Util.print2 "%s: %s\n\n" f (FStar_String.concat " " files1)))
  
let (print_raw : deps -> unit) =
  fun deps  ->
    let uu____57551 = deps.dep_graph  in
    match uu____57551 with
    | Deps deps1 ->
        let uu____57555 =
          let uu____57557 =
            FStar_Util.smap_fold deps1
              (fun k  ->
                 fun dep_node  ->
                   fun out  ->
                     let uu____57575 =
                       let uu____57577 =
                         let uu____57579 =
                           FStar_List.map dep_to_string dep_node.edges  in
                         FStar_All.pipe_right uu____57579
                           (FStar_String.concat ";\n\t")
                          in
                       FStar_Util.format2 "%s -> [\n\t%s\n] " k uu____57577
                        in
                     uu____57575 :: out) []
             in
          FStar_All.pipe_right uu____57557 (FStar_String.concat ";;\n")  in
        FStar_All.pipe_right uu____57555 FStar_Util.print_endline
  
let (print_full : deps -> unit) =
  fun deps  ->
    let sort_output_files orig_output_file_map =
      let order = FStar_Util.mk_ref []  in
      let remaining_output_files = FStar_Util.smap_copy orig_output_file_map
         in
      let visited_other_modules =
        FStar_Util.smap_create (Prims.parse_int "41")  in
      let should_visit lc_module_name =
        (let uu____57651 =
           FStar_Util.smap_try_find remaining_output_files lc_module_name  in
         FStar_Option.isSome uu____57651) ||
          (let uu____57658 =
             FStar_Util.smap_try_find visited_other_modules lc_module_name
              in
           FStar_Option.isNone uu____57658)
         in
      let mark_visiting lc_module_name =
        let ml_file_opt =
          FStar_Util.smap_try_find remaining_output_files lc_module_name  in
        FStar_Util.smap_remove remaining_output_files lc_module_name;
        FStar_Util.smap_add visited_other_modules lc_module_name true;
        ml_file_opt  in
      let emit_output_file_opt ml_file_opt =
        match ml_file_opt with
        | FStar_Pervasives_Native.None  -> ()
        | FStar_Pervasives_Native.Some ml_file ->
            let uu____57701 =
              let uu____57705 = FStar_ST.op_Bang order  in ml_file ::
                uu____57705
               in
            FStar_ST.op_Colon_Equals order uu____57701
         in
      let rec aux uu___437_57812 =
        match uu___437_57812 with
        | [] -> ()
        | lc_module_name::modules_to_extract ->
            let visit_file file_opt =
              match file_opt with
              | FStar_Pervasives_Native.None  -> ()
              | FStar_Pervasives_Native.Some file_name ->
                  let uu____57840 = deps_try_find deps.dep_graph file_name
                     in
                  (match uu____57840 with
                   | FStar_Pervasives_Native.None  ->
                       let uu____57843 =
                         FStar_Util.format2
                           "Impossible: module %s: %s not found"
                           lc_module_name file_name
                          in
                       failwith uu____57843
                   | FStar_Pervasives_Native.Some
                       { edges = immediate_deps; color = uu____57847;_} ->
                       let immediate_deps1 =
                         FStar_List.map
                           (fun x  ->
                              FStar_String.lowercase (module_name_of_dep x))
                           immediate_deps
                          in
                       aux immediate_deps1)
               in
            ((let uu____57856 = should_visit lc_module_name  in
              if uu____57856
              then
                let ml_file_opt = mark_visiting lc_module_name  in
                ((let uu____57864 =
                    implementation_of deps.file_system_map lc_module_name  in
                  visit_file uu____57864);
                 (let uu____57869 =
                    interface_of deps.file_system_map lc_module_name  in
                  visit_file uu____57869);
                 emit_output_file_opt ml_file_opt)
              else ());
             aux modules_to_extract)
         in
      let all_extracted_modules = FStar_Util.smap_keys orig_output_file_map
         in
      aux all_extracted_modules;
      (let uu____57881 = FStar_ST.op_Bang order  in
       FStar_List.rev uu____57881)
       in
    let keys = deps_keys deps.dep_graph  in
    let output_file ext fst_file =
      let ml_base_name =
        let uu____57955 =
          let uu____57957 =
            let uu____57961 = FStar_Util.basename fst_file  in
            check_and_strip_suffix uu____57961  in
          FStar_Option.get uu____57957  in
        FStar_Util.replace_chars uu____57955 46 "_"  in
      let uu____57966 = FStar_String.op_Hat ml_base_name ext  in
      FStar_Options.prepend_output_dir uu____57966  in
    let norm_path s = FStar_Util.replace_chars s 92 "/"  in
    let output_ml_file f =
      let uu____57988 = output_file ".ml" f  in norm_path uu____57988  in
    let output_krml_file f =
      let uu____58000 = output_file ".krml" f  in norm_path uu____58000  in
    let output_cmx_file f =
      let uu____58012 = output_file ".cmx" f  in norm_path uu____58012  in
    let cache_file f =
      let uu____58029 = FStar_All.pipe_right f cache_file_name_internal  in
      FStar_All.pipe_right uu____58029
        (fun uu____58058  ->
           match uu____58058 with | (f1,b) -> ((norm_path f1), b))
       in
    let set_of_unchecked_files =
      let uu____58083 =
        let uu____58094 = FStar_Util.new_set FStar_Util.compare  in
        FStar_List.fold_left
          (fun set_of_unchecked_files  ->
             fun file_name  ->
               let dep_node =
                 let uu____58131 = deps_try_find deps.dep_graph file_name  in
                 FStar_All.pipe_right uu____58131 FStar_Option.get  in
               let iface_deps =
                 let uu____58141 = is_interface file_name  in
                 if uu____58141
                 then FStar_Pervasives_Native.None
                 else
                   (let uu____58152 =
                      let uu____58156 = lowercase_module_name file_name  in
                      interface_of deps.file_system_map uu____58156  in
                    match uu____58152 with
                    | FStar_Pervasives_Native.None  ->
                        FStar_Pervasives_Native.None
                    | FStar_Pervasives_Native.Some iface ->
                        let uu____58168 =
                          let uu____58171 =
                            let uu____58172 =
                              deps_try_find deps.dep_graph iface  in
                            FStar_Option.get uu____58172  in
                          uu____58171.edges  in
                        FStar_Pervasives_Native.Some uu____58168)
                  in
               let iface_deps1 =
                 FStar_Util.map_opt iface_deps
                   (FStar_List.filter
                      (fun iface_dep  ->
                         let uu____58189 =
                           FStar_Util.for_some (dep_subsumed_by iface_dep)
                             dep_node.edges
                            in
                         Prims.op_Negation uu____58189))
                  in
               let norm_f = norm_path file_name  in
               let files =
                 FStar_List.map
                   (file_of_dep_aux true deps.file_system_map
                      deps.cmd_line_files) dep_node.edges
                  in
               let files1 =
                 match iface_deps1 with
                 | FStar_Pervasives_Native.None  -> files
                 | FStar_Pervasives_Native.Some iface_deps2 ->
                     let iface_files =
                       FStar_List.map
                         (file_of_dep_aux true deps.file_system_map
                            deps.cmd_line_files) iface_deps2
                        in
                     FStar_Util.remove_dups (fun x  -> fun y  -> x = y)
                       (FStar_List.append files iface_files)
                  in
               let files2 = FStar_List.map norm_path files1  in
               let files3 =
                 FStar_List.map
                   (fun s  -> FStar_Util.replace_chars s 32 "\\ ") files2
                  in
               let files4 = FStar_String.concat "\\\n\t" files3  in
               let uu____58248 = cache_file file_name  in
               match uu____58248 with
               | (cache_file_name1,b) ->
                   let set_of_unchecked_files1 =
                     if b
                     then set_of_unchecked_files
                     else FStar_Util.set_add file_name set_of_unchecked_files
                      in
                   (FStar_Util.print3 "%s: %s \\\n\t%s\n\n" cache_file_name1
                      norm_f files4;
                    (let uu____58277 =
                       let uu____58286 = FStar_Options.cmi ()  in
                       if uu____58286
                       then
                         topological_dependences_of deps.file_system_map
                           deps.dep_graph deps.interfaces_with_inlining
                           [file_name] true
                       else
                         (let maybe_widen_deps f_deps =
                            FStar_List.map
                              (fun dep1  ->
                                 file_of_dep_aux false deps.file_system_map
                                   deps.cmd_line_files dep1) f_deps
                             in
                          let fst_files = maybe_widen_deps dep_node.edges  in
                          let fst_files_from_iface =
                            match iface_deps1 with
                            | FStar_Pervasives_Native.None  -> []
                            | FStar_Pervasives_Native.Some iface_deps2 ->
                                maybe_widen_deps iface_deps2
                             in
                          let uu____58334 =
                            FStar_Util.remove_dups
                              (fun x  -> fun y  -> x = y)
                              (FStar_List.append fst_files
                                 fst_files_from_iface)
                             in
                          (uu____58334, false))
                        in
                     match uu____58277 with
                     | (all_fst_files_dep,widened) ->
                         let all_checked_fst_dep_files =
                           FStar_All.pipe_right all_fst_files_dep
                             (FStar_List.map
                                (fun f  ->
                                   let uu____58381 =
                                     FStar_All.pipe_right f cache_file  in
                                   FStar_All.pipe_right uu____58381
                                     FStar_Pervasives_Native.fst))
                            in
                         ((let uu____58405 = is_implementation file_name  in
                           if uu____58405
                           then
                             ((let uu____58409 =
                                 (FStar_Options.cmi ()) && widened  in
                               if uu____58409
                               then
                                 ((let uu____58413 = output_ml_file file_name
                                      in
                                   FStar_Util.print3 "%s: %s \\\n\t%s\n\n"
                                     uu____58413 cache_file_name1
                                     (FStar_String.concat " \\\n\t"
                                        all_checked_fst_dep_files));
                                  (let uu____58417 =
                                     output_krml_file file_name  in
                                   FStar_Util.print3 "%s: %s \\\n\t%s\n\n"
                                     uu____58417 cache_file_name1
                                     (FStar_String.concat " \\\n\t"
                                        all_checked_fst_dep_files)))
                               else
                                 ((let uu____58424 = output_ml_file file_name
                                      in
                                   FStar_Util.print2 "%s: %s \n\n"
                                     uu____58424 cache_file_name1);
                                  (let uu____58427 =
                                     output_krml_file file_name  in
                                   FStar_Util.print2 "%s: %s\n\n" uu____58427
                                     cache_file_name1)));
                              (let cmx_files =
                                 let extracted_fst_files =
                                   FStar_All.pipe_right all_fst_files_dep
                                     (FStar_List.filter
                                        (fun df  ->
                                           (let uu____58452 =
                                              lowercase_module_name df  in
                                            let uu____58454 =
                                              lowercase_module_name file_name
                                               in
                                            uu____58452 <> uu____58454) &&
                                             (let uu____58458 =
                                                lowercase_module_name df  in
                                              FStar_Options.should_extract
                                                uu____58458)))
                                    in
                                 FStar_All.pipe_right extracted_fst_files
                                   (FStar_List.map output_cmx_file)
                                  in
                               let uu____58468 =
                                 let uu____58470 =
                                   lowercase_module_name file_name  in
                                 FStar_Options.should_extract uu____58470  in
                               if uu____58468
                               then
                                 let uu____58473 = output_cmx_file file_name
                                    in
                                 let uu____58475 = output_ml_file file_name
                                    in
                                 FStar_Util.print3 "%s: %s \\\n\t%s\n\n"
                                   uu____58473 uu____58475
                                   (FStar_String.concat "\\\n\t" cmx_files)
                               else ()))
                           else
                             (let uu____58483 =
                                (let uu____58487 =
                                   let uu____58489 =
                                     lowercase_module_name file_name  in
                                   has_implementation deps.file_system_map
                                     uu____58489
                                    in
                                 Prims.op_Negation uu____58487) &&
                                  (is_interface file_name)
                                 in
                              if uu____58483
                              then
                                let uu____58492 =
                                  (FStar_Options.cmi ()) && widened  in
                                (if uu____58492
                                 then
                                   let uu____58495 =
                                     output_krml_file file_name  in
                                   FStar_Util.print3 "%s: %s \\\n\t%s\n\n"
                                     uu____58495 cache_file_name1
                                     (FStar_String.concat " \\\n\t"
                                        all_checked_fst_dep_files)
                                 else
                                   (let uu____58501 =
                                      output_krml_file file_name  in
                                    FStar_Util.print2 "%s: %s \n\n"
                                      uu____58501 cache_file_name1))
                              else ()));
                          set_of_unchecked_files1)))) uu____58094
         in
      FStar_All.pipe_right keys uu____58083  in
    let uu____58512 =
      let uu____58523 =
        let uu____58527 =
          FStar_All.pipe_right keys (FStar_List.filter is_implementation)  in
        FStar_All.pipe_right uu____58527
          (FStar_Util.sort_with FStar_String.compare)
         in
      FStar_All.pipe_right uu____58523
        (fun l  ->
           let uu____58564 =
             FStar_All.pipe_right l
               (FStar_List.filter
                  (fun f  -> FStar_Util.set_mem f set_of_unchecked_files))
              in
           (l, uu____58564))
       in
    match uu____58512 with
    | (all_fst_files,all_unchecked_fst_files) ->
        let all_ml_files =
          let ml_file_map = FStar_Util.smap_create (Prims.parse_int "41")  in
          FStar_All.pipe_right all_fst_files
            (FStar_List.iter
               (fun fst_file  ->
                  let mname = lowercase_module_name fst_file  in
                  let uu____58622 = FStar_Options.should_extract mname  in
                  if uu____58622
                  then
                    let uu____58625 = output_ml_file fst_file  in
                    FStar_Util.smap_add ml_file_map mname uu____58625
                  else ()));
          sort_output_files ml_file_map  in
        let all_krml_files =
          let krml_file_map = FStar_Util.smap_create (Prims.parse_int "41")
             in
          FStar_All.pipe_right keys
            (FStar_List.iter
               (fun fst_file  ->
                  let mname = lowercase_module_name fst_file  in
                  let uu____58652 = output_krml_file fst_file  in
                  FStar_Util.smap_add krml_file_map mname uu____58652));
          sort_output_files krml_file_map  in
        ((let uu____58656 =
            let uu____58658 =
              FStar_All.pipe_right all_fst_files (FStar_List.map norm_path)
               in
            FStar_All.pipe_right uu____58658 (FStar_String.concat " \\\n\t")
             in
          FStar_Util.print1 "ALL_FST_FILES=\\\n\t%s\n\n" uu____58656);
         (let uu____58677 =
            let uu____58679 =
              FStar_All.pipe_right all_unchecked_fst_files
                (FStar_List.map norm_path)
               in
            FStar_All.pipe_right uu____58679 (FStar_String.concat " \\\n\t")
             in
          FStar_Util.print1 "ALL_UNCHECKED_FST_FILES=\\\n\t%s\n\n"
            uu____58677);
         (let uu____58698 =
            let uu____58700 =
              FStar_All.pipe_right all_ml_files (FStar_List.map norm_path)
               in
            FStar_All.pipe_right uu____58700 (FStar_String.concat " \\\n\t")
             in
          FStar_Util.print1 "ALL_ML_FILES=\\\n\t%s\n\n" uu____58698);
         (let uu____58718 =
            let uu____58720 =
              FStar_All.pipe_right all_krml_files (FStar_List.map norm_path)
               in
            FStar_All.pipe_right uu____58720 (FStar_String.concat " \\\n\t")
             in
          FStar_Util.print1 "ALL_KRML_FILES=\\\n\t%s\n" uu____58718))
  
let (print : deps -> unit) =
  fun deps  ->
    let uu____58744 = FStar_Options.dep ()  in
    match uu____58744 with
    | FStar_Pervasives_Native.Some "make" -> print_make deps
    | FStar_Pervasives_Native.Some "full" -> print_full deps
    | FStar_Pervasives_Native.Some "graph" -> print_graph deps.dep_graph
    | FStar_Pervasives_Native.Some "raw" -> print_raw deps
    | FStar_Pervasives_Native.Some uu____58756 ->
        FStar_Errors.raise_err
          (FStar_Errors.Fatal_UnknownToolForDep, "unknown tool for --dep\n")
    | FStar_Pervasives_Native.None  -> ()
  
let (print_fsmap :
  (Prims.string FStar_Pervasives_Native.option * Prims.string
    FStar_Pervasives_Native.option) FStar_Util.smap -> Prims.string)
  =
  fun fsmap  ->
    FStar_Util.smap_fold fsmap
      (fun k  ->
         fun uu____58811  ->
           fun s  ->
             match uu____58811 with
             | (v0,v1) ->
                 let uu____58840 =
                   let uu____58842 =
                     FStar_Util.format3 "%s -> (%s, %s)" k
                       (FStar_Util.dflt "_" v0) (FStar_Util.dflt "_" v1)
                      in
                   FStar_String.op_Hat "; " uu____58842  in
                 FStar_String.op_Hat s uu____58840) ""
  
let (module_has_interface : deps -> FStar_Ident.lident -> Prims.bool) =
  fun deps  ->
    fun module_name  ->
      let uu____58863 =
        let uu____58865 = FStar_Ident.string_of_lid module_name  in
        FStar_String.lowercase uu____58865  in
      has_interface deps.file_system_map uu____58863
  
let (deps_has_implementation : deps -> FStar_Ident.lident -> Prims.bool) =
  fun deps  ->
    fun module_name  ->
      let m =
        let uu____58881 = FStar_Ident.string_of_lid module_name  in
        FStar_String.lowercase uu____58881  in
      FStar_All.pipe_right deps.all_files
        (FStar_Util.for_some
           (fun f  ->
              (is_implementation f) &&
                (let uu____58892 =
                   let uu____58894 = module_name_of_file f  in
                   FStar_String.lowercase uu____58894  in
                 uu____58892 = m)))
  