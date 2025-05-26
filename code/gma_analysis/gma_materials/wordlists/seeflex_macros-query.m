MACRO qCont()
([word = RE($Cont)%cd & pos != "AT|P.*"])
;

MACRO qConj()
([word = RE($ConjTh)%cd & pos != "R.*|J.*|I.*"])
;

MACRO qConjSo()
[word = "so"%c & pos = "R.*"]
;

MACRO qConjAdj()
((/ConjAdj1[]) | (/ConjAdj2[]))
;

MACRO qModAdj()
((/ModAdj1[]) | (/ModAdj2[]))
;

MACRO qTextTh()
/qCont[]? /qConj[]? /qConjSo[]? /qConjAdj[]?
;

MACRO qIntTh()
/qModAdj[]?
;
