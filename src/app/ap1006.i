DEF TEMP-TABLE tt-imposto-pagto NO-UNDO LIKE imposto-pagto
    FIELD i-fornec-matriz LIKE tit-ap.matriz
    FIELD l-impto-gerado  AS LOGICAL FORMAT "Sim/NÆo" LABEL "Impto Gerado?"
    FIELD l-existe-titulo AS LOGICAL FORMAT "Sim/NÆo" LABEL "Existe T¡tulo?".

DEF VAR de-tot-vl-base    LIKE imposto-pagto.vl-base    NO-UNDO.
DEF VAR de-tot-vl-imposto LIKE imposto-pagto.vl-imposto NO-UNDO.

