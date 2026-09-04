{lib, ...}:
{
  attrListMerge = l: lib.lists.foldr (a: b: a//b) {} l;
}