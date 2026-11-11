{lib, ...}: 
let 
_mergeAttrsRec = combLists: (a: b: a // 
  (
    lib.lists.foldl 
    (p: kv: p // {
      ${kv.name} = (
        if builtins.isAttrs kv.value then
          _mergeAttrsRec combLists (a.${kv.name} or {}) kv.value
        else if combLists && builtins.isList kv.value then
          (a.${kv.name} or []) ++ kv.value
        else 
          kv.value
      );
    })
    {}
    (lib.attrsToList b)
  )
);
attrMergeRec = rec
{
  mergeAttrsRec = _mergeAttrsRec false;

  mergeAttrsRecComb = _mergeAttrsRec true;

  attrListMerge = l: lib.lists.foldl mergeAttrsRecComb {} l;

  attrListMergeShallow = l: lib.lists.foldr (a: b: a//b) {} l;
}; in {
  inherit attrMergeRec;
} // attrMergeRec