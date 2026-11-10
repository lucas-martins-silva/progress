/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i IM0440A 2.00.00.018 } /*** "010018" 22/01/2026 14:18:20 ***/
/*****************************************************************************
**
**       Programa: im0440a.p
**
**       Data....: 03/01/2012
**
**       Autor...: DATASUL S.A.
**
**       Objetivo: Extrado da Declaraá∆o de Importaá∆o, layout: DI-EMS/Adiá∆o/Sequencia
**
**       Vers∆o..: 1.00.000 - imp
**
**       OBS.....: 
**
*******************************************************************************/
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_dialet_corren AS CHARACTER    NO-UNDO.
FIND FIRST param-global NO-LOCK NO-ERROR.

/****************** Definiá∆o de Tabelas Temporˇrias do Relat¢rio **********************/
/* 
 * a include im0440.i possui a definiá∆o das vari†veis e temp-tables usadas no relat¢rio em ambos os layout (por adiá∆o / por embarque)
 * definiá∆o dos frames usados pelos dois layouts.
 * criaá∆o das temp-tables
*/
{imp/im0440.i}
{cxbo/bocx393.i tt-decla-imp-adic-nve}
{cxbo/bocx402.i tt-decla-imp-adic-itens}

//{cxbo/bocx403.i tt-decla-imp-adic}
DEFINE TEMP-TABLE tt-decla-imp-adic NO-UNDO LIKE decla-import-adic
    FIELD r-Rowid              AS ROWID
    FIELD cod-trib-ibs-uf      AS CHARACTER FORMAT "x(10)"
    FIELD val-aliq-ibs-uf      AS DECIMAL   FORMAT ">>9.99"
    FIELD perc-reduc-ibs-uf    AS DECIMAL   FORMAT ">>9.99"
    FIELD val-base-ibs-uf      AS DECIMAL   FORMAT ">,>>>,>>>,>>9.99999999"
    FIELD val-ibs-uf-db-cr     AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99999999"
    FIELD cod-trib-ibs-mun     AS CHARACTER FORMAT "x(10)"
    FIELD val-aliq-ibs-mun     AS DECIMAL   FORMAT ">>9.99"
    FIELD perc-reduc-ibs-mun   AS DECIMAL   FORMAT ">>9.99"
    FIELD val-base-ibs-mun     AS DECIMAL   FORMAT ">,>>>,>>>,>>9.99999999"
    FIELD val-ibs-mun-db-cr    AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99999999"
    FIELD cod-trib-cbs         AS CHARACTER FORMAT "x(10)"
    FIELD val-aliq-cbs         AS DECIMAL   FORMAT ">>9.99"
    FIELD perc-reduc-cbs       AS DECIMAL   FORMAT ">>9.99"
    FIELD val-base-cbs         AS DECIMAL   FORMAT ">,>>>,>>>,>>9.99999999"
    FIELD val-cbs-db-cr        AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99999999"
    FIELD val-aliq-ibs-uf-reg  AS DECIMAL   FORMAT ">>9.99"
    FIELD val-base-ibs-uf-reg  AS DECIMAL   FORMAT ">,>>>,>>>,>>9.99999999"
    FIELD val-ibs-uf-reg       AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99999999"
    FIELD val-aliq-ibs-mun-reg AS DECIMAL   FORMAT ">>9.99"
    FIELD val-base-ibs-mun-reg AS DECIMAL   FORMAT ">,>>>,>>>,>>9.99999999"
    FIELD val-ibs-mun-reg      AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99999999"
    FIELD val-aliq-cbs-reg     AS DECIMAL   FORMAT ">>9.99"
    FIELD val-base-cbs-reg     AS DECIMAL   FORMAT ">,>>>,>>>,>>9.99999999"
    FIELD val-cbs-reg          AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99999999".
    
DEF TEMP-TABLE tt-despes-adic NO-UNDO LIKE despes-adic
    FIELD r-Rowid   AS ROWID.

DEFINE VARIABLE h-bocx398 AS HANDLE  NO-UNDO.
IF NOT VALID-HANDLE(h-bocx398) THEN DO:
    RUN cxbo/bocx398.p PERSISTENT SET h-bocx398.
END.

DEFINE VARIABLE h-bocx397 AS HANDLE  NO-UNDO.
IF NOT VALID-HANDLE(h-bocx397) THEN DO:
    RUN cxbo/bocx397.p PERSISTENT SET h-bocx397.
END.

DEFINE VARIABLE h-bocx402 AS HANDLE  NO-UNDO.
IF NOT VALID-HANDLE(h-bocx402) THEN DO:
    RUN cxbo/bocx402.p PERSISTENT SET h-bocx402.
END.

DEFINE VARIABLE c-cabecAdic         AS CHARACTER FORMAT "X(132)"            NO-UNDO.
DEFINE VARIABLE c-nome-fornec       LIKE emitente.nome-abrev                NO-UNDO.
DEFINE VARIABLE c-pais-fornec       LIKE emitente.pais                      NO-UNDO.
DEFINE VARIABLE c-nome-fabrican     AS CHAR FORMAT "x(40)" /*LIKE emitente.nome-abrev*/                NO-UNDO.
DEFINE VARIABLE c-pais-fabrican     LIKE emitente.pais                      NO-UNDO.
DEFINE VARIABLE c-desc-classif-fisc LIKE classif-fisc.descricao             NO-UNDO.
DEFINE VARIABLE c-cond-mercadoria   AS CHARACTER FORMAT "X(20)"             NO-UNDO.
DEFINE VARIABLE c-li                LIKE decla-import-ord.cod-licenc-import NO-UNDO.
DEFINE VARIABLE c-metod-valor       AS CHARACTER FORMAT "X(30)"             NO-UNDO.
DEFINE VARIABLE c-classif-unidade   LIKE classif-fisc.unidade               NO-UNDO.
DEFINE VARIABLE c-classif-fisc      AS CHARACTER FORMAT "X(14)"             NO-UNDO.

/*vari†veis usadas na frame NVE*/
DEFINE VARIABLE c-nve-nivel     AS CHARACTER FORMAT "X(30)"  NO-UNDO.
DEFINE VARIABLE c-nve-atributo  AS CHARACTER FORMAT "X(33)"  NO-UNDO.
DEFINE VARIABLE c-nve-especif   AS CHARACTER FORMAT "X(65)"  NO-UNDO.

/*vari†veis usadas na frame de valores da adicao (f-valAdic)*/
DEFINE VARIABLE c-val-moeda         LIKE moeda.descricao NO-UNDO.
DEFINE VARIABLE c-desc-moeda-frete  LIKE moeda.descricao NO-UNDO.
DEFINE VARIABLE c-desc-moeda-seguro LIKE moeda.descricao NO-UNDO.
DEFINE VARIABLE c-desc-moeda-vmle   LIKE moeda.descricao NO-UNDO.
DEFINE VARIABLE c-desc-moeda-vmld   LIKE moeda.descricao NO-UNDO.
DEFINE VARIABLE c-desc-moeda-vmcv   LIKE moeda.descricao NO-UNDO.
DEFINE VARIABLE c-desc-moeda-acresc LIKE moeda.descricao NO-UNDO.

/*vari†veis usadas na frame Impostos Adiá∆o (f-impAdic)*/
DEFINE VARIABLE c-tributac-ii     AS CHAR FORMAT "X(11)" NO-UNDO.
DEFINE VARIABLE c-tributac-ipi    AS CHAR FORMAT "X(11)" NO-UNDO.
DEFINE VARIABLE c-tributac-pis    AS CHAR FORMAT "X(11)" NO-UNDO.
DEFINE VARIABLE c-tributac-cofins AS CHAR FORMAT "X(11)" NO-UNDO.
DEFINE VARIABLE c-tributac-icms   AS CHAR FORMAT "X(11)" NO-UNDO.
DEFINE VARIABLE d-tot-perc-reduc  LIKE decla-import-adic.val-perc-reduc-icms NO-UNDO.
DEFINE VARIABLE d-tot-val-db-cr   LIKE decla-import-adic.val-icms-db-cr      NO-UNDO.

DEFINE VARIABLE de-val-aliq-fcp           LIKE decla-import-adic-itens.val-aliq-fcp           NO-UNDO.
DEFINE VARIABLE de-val-base-fcp           LIKE decla-import-adic-itens.val-base-fcp           NO-UNDO.
DEFINE VARIABLE de-val-fcp                LIKE decla-import-adic-itens.val-fcp                NO-UNDO.
DEFINE VARIABLE de-val-aliq-fcp-substto   LIKE decla-import-adic-itens.val-aliq-fcp-substto   NO-UNDO. 
DEFINE VARIABLE de-val-base-fcp-substto   LIKE decla-import-adic-itens.val-base-fcp-substto   NO-UNDO.
DEFINE VARIABLE de-val-fcp-substto        LIKE decla-import-adic-itens.val-fcp-substto        NO-UNDO.
DEFINE VARIABLE de-val-base-icms-substto  LIKE decla-import-adic-itens.val-base-icms-substto  NO-UNDO.
DEFINE VARIABLE de-val-icms-substto       LIKE decla-import-adic-itens.val-icms-substto       NO-UNDO.
DEFINE VARIABLE de-val-base-icms-compltar LIKE decla-import-adic-itens.val-base-icms-compltar NO-UNDO.
DEFINE VARIABLE de-val-icms-compltar      LIKE decla-import-adic-itens.val-icms-compltar      NO-UNDO.


/*variaveis usadas na frame do cambio da adicao (f-cambioAdic)*/
DEFINE VARIABLE c-pagamento         AS CHAR FORMAT "X(20)"   NO-UNDO.
DEFINE VARIABLE c-corretor-cambio   AS CHAR FORMAT "X(40)"   NO-UNDO.
DEFINE VARIABLE c-banco             AS CHAR FORMAT "X(25)"   NO-UNDO.
DEFINE VARIABLE c-agente            AS CHAR FORMAT "X(41)"   NO-UNDO.
DEFINE VARIABLE c-banco-agente      AS CHAR FORMAT "X(25)"   NO-UNDO.
DEFINE VARIABLE c-cabec-cambio-adic AS CHAR FORMAT "X(132)"  NO-UNDO.
DEFINE VARIABLE c-desc-banco        LIKE banco.nome-banco    NO-UNDO.
DEFINE VARIABLE c-desc-banco-agent  LIKE banco.nome-banco    NO-UNDO.
DEFINE VARIABLE c-desc-corretor     LIKE emitente.nome-abrev NO-UNDO.
DEFINE VARIABLE c-desc-agente       LIKE emitente.nome-abrev NO-UNDO.

DEFINE VARIABLE i-cod-destaq  LIKE classif-destaq.cod-destaq NO-UNDO.
DEFINE VARIABLE c-dsl-destaq  AS CHAR FORMAT "X(110)"        NO-UNDO.
DEFINE VARIABLE i-trib-ibsuf  AS INTEGER                     NO-UNDO.
DEFINE VARIABLE i-trib-ibsmun AS INTEGER                     NO-UNDO.
DEFINE VARIABLE i-trib-cbs    AS INTEGER                     NO-UNDO.

/*definiá∆o dos forms que s¢ ser∆o utilizados por este layout (im0440a.p)*/
FORM HEADER 
        SKIP(2)
        "*" FILL("-",59) FORMAT "X(59)" "Adiá‰es" FILL("-",60) FORMAT "X(60)" "*"
    WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecAdicoes.
DEF VAR c-ind-vinc AS CHAR FORMAT "X(30)" NO-UNDO.
FORM 
    SKIP(1)
    c-cabecAdic                                 NO-LABEL                            AT 001
    SKIP(1)
    tt-decla-imp-adic.cdn-fornec                label "Fornecedor"                  AT 012  
    c-nome-fornec                               NO-LABEL                            AT 034        
    c-pais-fornec                               label "Pa°s"                        AT 092  SKIP
    tt-decla-imp-adic.log-emite-fabrican        label "Fornec. Ç Fabricante"        AT 002          
    c-ind-vinc /*tt-decla-imp-adic.idi-ind-vincul*/            FORMAT "x(30)" label "Indicativo de V°nculo"       AT 075  skip
    tt-decla-imp-adic.cdn-fabrican              label "Produtor"                    AT 014          
    c-nome-fabrican                             NO-LABEL                            AT 034        
    c-pais-fabrican                             label "Pa°s"                        AT 092  skip
    SKIP(1)                                                                                
    c-classif-fisc                              label "Classif.Fiscal"              AT 008          
    c-desc-classif-fisc                         NO-LABEL                            AT 038
   WITH WIDTH 132 SIDE-LABEL NO-BOX STREAM-IO FRAME f-adicoes1.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-adicoes1:HANDLE).


FORM
    SKIP(2)
    tt-decla-imp-adic.cdn-naladi-sist-harmon    label "NALADI/SH"                   AT 013          
    tt-decla-imp-adic.cod-naladi-ncca           label "NALADI/NCCA"                 AT 085  skip
    tt-decla-imp-adic.cod-incoterm              label "Incoterm"                    AT 014          
    tt-decla-imp-adic.cod-nbm                   label "NBM"                         AT 093  skip
    tt-decla-imp-adic.cod-aladi                 label "Acordo Aladi"                AT 010  
    c-li                                        label "LI"                          AT 094  SKIP
    c-metod-valor                               label "MÇtodo Valoraá∆o"            AT 006
    c-cond-mercadoria                           label "Condiá∆o Mercadoria"         AT 077  SKIP
    tt-decla-imp-adic.cod-tip-recip             label "Tipo Recipiente"             AT 007          
    tt-decla-imp-adic.qtd-capac-recip           label "Capacidade Recipiente (ml)"  AT 070  skip
    tt-decla-imp-adic.val-peso-liq              label "Peso L°quido (Kg)"           AT 005          
    tt-decla-imp-adic.qtd-ncm                   label "Qtde. Unid. NCM"             AT 081
    c-classif-unidade                           NO-LABEL                            AT 118
   WITH WIDTH 132 SIDE-LABEL NO-BOX STREAM-IO FRAME f-adicoes2.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-adicoes2:HANDLE).


FORM HEADER 
    SKIP(1)
    "Destaque"                      AT 008
    "Descriá∆o"                     AT 018
    SKIP                            
    "--------"                      AT 008
    FILL("-",110) FORMAT "X(110)"   AT 018
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecDestaqClassif.

FORM 
    i-cod-destaq                    AT 010
    c-dsl-destaq                    AT 018
   WITH DOWN WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-destaqClassif.

/*NVE*/
FORM HEADER
   SKIP(2)
    "*" FILL("-",61) FORMAT "X(61)" "NVE" FILL("-",62) FORMAT "X(62)" "*" 
   SKIP
    "N°vel"                         AT 002
    "Atributo"                      AT 033
    "Especificaá∆o"                 AT 067
   SKIP
    FILL("-",30) FORMAT "X(30)"     AT 002 
    FILL("-",33) FORMAT "X(33)"     AT 033 
    FILL("-",65) FORMAT "X(65)"     AT 067 
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecAdicNve. 

FORM c-nve-nivel        AT 002
     c-nve-atributo     AT 033
     c-nve-especif      AT 067
    WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-adicNve.
/* fim - NVE*/

/* Itens Adiá∆o*/
DEFINE VARIABLE i-num-adic LIKE decla-import-adic.num-adic NO-UNDO.
FORM HEADER
    SKIP(2)
    "*" FILL("-",52) FORMAT "X(52)" "ITENS ADIC«O NR. " i-num-adic FILL("-",53) FORMAT "X(53)" "*"
    SKIP
    "Seq"                             at 006
    "ITEM"                            at 012
    "Qtde"                            at 044
    "UN"                              at 052
    "Mo"                              at 057
    "VUCV"                            at 082
    "N.Op"                            at 089
    "Embarque"                        at 107
    "Ordem/Parc"                      at 118
   SKIP
    "-----"                           at 006
    "----------------"                at 012
    "-----------------"               at 031
    "---"                             at 051
    "--"                              at 057
    "------------------------"        at 062
    "------"                          at 089
    "-----------------"               at 098
    "----------"                      at 118
  WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecItemAdic.

DEFINE VARIABLE c-especificacao AS CHARACTER FORMAT "X(116)"  NO-UNDO.
DEFINE VARIABLE c-ordem-parcela AS CHARACTER FORMAT "X(10)"   NO-UNDO.
DEFINE VARIABLE c-un            LIKE ITEM.un                  NO-UNDO.
DEFINE VARIABLE d-val-vucv      LIKE decla-import-adic-itens.val-vucv NO-UNDO.
FORM
     tt-decla-imp-adic-itens.num-seq            at 006 
     tt-decla-imp-adic-itens.cod-item           at 012 
     tt-decla-imp-adic-itens.qtd-adic[1]        at 031 
     c-un                                       at 051 
     tt-decla-imp-adic-itens.cdn-moed-vucv      at 057 
     d-val-vucv                                 at 062 
     tt-decla-imp-adic-itens.cod-natur-operac   at 089 
     tt-decla-imp-adic-itens.cod-embarq         at 098 
     c-ordem-parcela                            at 118 
    SKIP
     c-especificacao                            AT 012
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-itemAdic.
/* fim - Itens Adiá∆o*/

/*valores adicao*/
FORM HEADER
    SKIP(2)
    "*" FILL("-",52) FORMAT "X(52)" "VALORES ADIÄ«O NR." i-num-adic FILL("-",52) FORMAT "X(52)" "*"
    SKIP
    "Moeda"                     AT 040
    "Valor MN"                  at 078
    "Valor ME"                  at 103
    SKIP 
    "---------------------"     at 040
    "------------------------"  at 062
    "------------------------"  at 087
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecValAdic.

FORM
    "VMLE:"                                 AT 034
    c-desc-moeda-vmle                       AT 040        
    tt-decla-imp-adic.val-vmle              AT 062       
    tt-decla-imp-adic.val-vmle-me[2]        AT 087         
   SKIP                                                    
    "VMLD:"                                 AT 034         
    c-desc-moeda-vmld                       AT 040       
    tt-decla-imp-adic.val-vmld              AT 062
    tt-decla-imp-adic.val-vmld-me[2]        AT 087
   SKIP                                    
    "VMCV:"                                 AT 034
    c-desc-moeda-vmcv                       AT 040
    tt-decla-imp-adic.val-vmcv              AT 062
    tt-decla-imp-adic.val-vmcv-me[2]        AT 087
   SKIP                    
    "Frete:"                                AT 033
    c-desc-moeda-frete                      AT 040
    tt-decla-imp-adic.val-frete             AT 062
    tt-decla-imp-adic.val-frete-me[2]       AT 087
   SKIP                    
    "Seguro:"                               AT 032
    c-desc-moeda-seguro                     AT 040
    tt-decla-imp-adic.val-seguro            AT 062
    tt-decla-imp-adic.val-seguro-me[2]      AT 087
   SKIP                    
    "AcrÇscimos:"                           AT 028
    c-desc-moeda-acresc                     AT 040
    tt-decla-imp-adic.val-acresc            AT 062
    tt-decla-imp-adic.val-acresc-me[2]      AT 087
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-valAdic.
/* fim valores adicao*/

/* impostos adicao*/
FORM HEADER
    SKIP(3)
    "*" FILL("-",51) FORMAT "X(51)" "IMPOSTOS ADIÄ«O NR." i-num-adic FILL("-",52) FORMAT "X(52)" "*"
   SKIP
    "Tributaá∆o"                    at 011
    "Al°quota"                      at 025
    "Suspenso"                      at 036
    "Reduá∆o"                       at 048
    "Vl.Unit†rio"                   at 070
    "Base C†lculo"                  at 093
    "Valor"                         at 124
   SKIP                            
    fill("-",11) format "x(11)"     at 011
    fill("-",08) format "x(08)"     at 025
    fill("-",08) format "x(08)"     at 036
    fill("-",08) format "x(08)"     at 047
    fill("-",24) format "x(24)"     at 057
    fill("-",22) format "x(22)"     at 083
    fill("-",22) format "x(22)"     at 107
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecImpAdic.

   
/* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-798) */
FORM 
    "II:"                                           at 009
    c-tributac-ii                                   at 012 
    tt-decla-imp-adic.val-aliq-ii                   at 025 
    tt-decla-imp-adic.log-suspens-impto-import      at 036 
    tt-decla-imp-adic.val-perc-reduc-impto-import   at 047 
    tt-decla-imp-adic.val-unit-ii                   at 057 
    tt-decla-imp-adic.val-base-ii                   at 083 
    tt-decla-imp-adic.val-ii-db-cr                  at 107 
   SKIP
    "IPI:"                                          at 008
    c-tributac-ipi                                  at 012 
    tt-decla-imp-adic.val-aliq-ipi                  at 025 
    tt-decla-imp-adic.log-suspens-ipi-import        at 036 
    tt-decla-imp-adic.val-perc-reduc-ipi            at 047 
    tt-decla-imp-adic.val-unit-ipi                  at 057 
    tt-decla-imp-adic.val-base-ipi                  at 083 
    tt-decla-imp-adic.val-ipi-db-cr                 at 107 
   SKIP 
    "PIS:"                                          at 008
    c-tributac-pis                                  at 012 
    tt-decla-imp-adic.val-aliq-pis                  at 025 
    tt-decla-imp-adic.val-perc-reduc-pis            at 047 
    tt-decla-imp-adic.val-unit-pis                  at 057 
    tt-decla-imp-adic.val-base-pis                  at 083 
    tt-decla-imp-adic.val-pis-db-cr                 at 107 
   SKIP 
    "COFINS:"                                       at 005
    c-tributac-cofins                               at 012 
    tt-decla-imp-adic.val-aliq-cofins               at 025 
    tt-decla-imp-adic.val-perc-reduc-cofins         at 047 
    tt-decla-imp-adic.val-unit-cofins               at 057 
    tt-decla-imp-adic.val-base-cofins               at 083 
    tt-decla-imp-adic.val-cofins-db-cr              at 107 
   SKIP 
    "ICMS:"                                         at 007
    c-tributac-icms                                 at 012 
    tt-decla-imp-adic.val-aliq-icms                 at 025 
    tt-decla-imp-adic.val-perc-reduc-icms           at 047 
    tt-decla-imp-adic.val-unit-icms                 at 057 
    tt-decla-imp-adic.val-base-icms                 at 083 
    tt-decla-imp-adic.val-icms-db-cr                at 107
   SKIP 
    "FCP:"                                          at 008 
    de-val-aliq-fcp                                 at 025  
    de-val-base-fcp                                 at 083 
    de-val-fcp                                      at 107 
   SKIP 
    "FCP ST:"                                       at 005
    de-val-aliq-fcp-substto                         at 025  
    de-val-base-fcp-substto                         at 083 
    de-val-fcp-substto                              at 107    
   SKIP 
    "ICMS ST:"                                      at 004
    de-val-base-icms-substto                        at 083
    de-val-icms-substto                             at 107
   SKIP 
    "ICMS Compl:"                                   at 001
    de-val-base-icms-compltar                       at 083
    de-val-icms-compltar                            at 107
    
   SKIP 
    "IBS UF:"                                       at 005
    tt-decla-imp-adic.cod-trib-ibs-uf               at 012 
    tt-decla-imp-adic.val-aliq-ibs-uf               at 025 
    tt-decla-imp-adic.perc-reduc-ibs-uf             at 047 
    tt-decla-imp-adic.val-base-ibs-uf               at 083 
    tt-decla-imp-adic.val-ibs-uf-db-cr              at 107
   SKIP 
    "IBS Mun:"                                      at 004
    tt-decla-imp-adic.cod-trib-ibs-mun              at 012 
    tt-decla-imp-adic.val-aliq-ibs-mun              at 025 
    tt-decla-imp-adic.perc-reduc-ibs-mun            at 047 
    tt-decla-imp-adic.val-base-ibs-mun              at 083 
    tt-decla-imp-adic.val-ibs-mun-db-cr             at 107
   SKIP 
    "CBS:"                                          at 008
    tt-decla-imp-adic.cod-trib-cbs                  at 012 
    tt-decla-imp-adic.val-aliq-cbs                  at 025 
    tt-decla-imp-adic.perc-reduc-cbs                at 047 
    tt-decla-imp-adic.val-base-cbs                  at 083 
    tt-decla-imp-adic.val-cbs-db-cr                 at 107 
   SKIP 
    "IBS UF Reg"                                    at 002
    tt-decla-imp-adic.val-aliq-ibs-uf-reg           at 025 
    tt-decla-imp-adic.val-base-ibs-uf-reg           at 083 
    tt-decla-imp-adic.val-ibs-uf-reg                at 107
   SKIP 
    "IBS Mun Reg"                                   at 001
    tt-decla-imp-adic.val-aliq-ibs-mun-reg          at 025 
    tt-decla-imp-adic.val-base-ibs-mun-reg          at 083 
    tt-decla-imp-adic.val-ibs-mun-reg               at 107
   SKIP 
    "CBS Reg"                                       at 005
    tt-decla-imp-adic.val-aliq-cbs-reg              at 025 
    tt-decla-imp-adic.val-base-cbs-reg              at 083 
    tt-decla-imp-adic.val-cbs-reg                   at 107 
    
   SKIP(1)
    "Totais:"                                       AT 005
    d-tot-perc-reduc                                AT 047
    d-tot-val-db-cr                                 AT 107
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-impAdicCbsIbs.
/* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-798) */

FORM 
    "II:"                                           at 009
    c-tributac-ii                                   at 012 
    tt-decla-imp-adic.val-aliq-ii                   at 025 
    tt-decla-imp-adic.log-suspens-impto-import      at 036 
    tt-decla-imp-adic.val-perc-reduc-impto-import   at 047 
    tt-decla-imp-adic.val-unit-ii                   at 057 
    tt-decla-imp-adic.val-base-ii                   at 083 
    tt-decla-imp-adic.val-ii-db-cr                  at 107 
   SKIP
    "IPI:"                                          at 008
    c-tributac-ipi                                  at 012 
    tt-decla-imp-adic.val-aliq-ipi                  at 025 
    tt-decla-imp-adic.log-suspens-ipi-import        at 036 
    tt-decla-imp-adic.val-perc-reduc-ipi            at 047 
    tt-decla-imp-adic.val-unit-ipi                  at 057 
    tt-decla-imp-adic.val-base-ipi                  at 083 
    tt-decla-imp-adic.val-ipi-db-cr                 at 107 
   SKIP 
    "PIS:"                                          at 008
    c-tributac-pis                                  at 012 
    tt-decla-imp-adic.val-aliq-pis                  at 025 
    tt-decla-imp-adic.val-perc-reduc-pis            at 047 
    tt-decla-imp-adic.val-unit-pis                  at 057 
    tt-decla-imp-adic.val-base-pis                  at 083 
    tt-decla-imp-adic.val-pis-db-cr                 at 107 
   SKIP 
    "COFINS:"                                       at 005
    c-tributac-cofins                               at 012 
    tt-decla-imp-adic.val-aliq-cofins               at 025 
    tt-decla-imp-adic.val-perc-reduc-cofins         at 047 
    tt-decla-imp-adic.val-unit-cofins               at 057 
    tt-decla-imp-adic.val-base-cofins               at 083 
    tt-decla-imp-adic.val-cofins-db-cr              at 107 
   SKIP 
    "ICMS:"                                         at 007
    c-tributac-icms                                 at 012 
    tt-decla-imp-adic.val-aliq-icms                 at 025 
    tt-decla-imp-adic.val-perc-reduc-icms           at 047 
    tt-decla-imp-adic.val-unit-icms                 at 057 
    tt-decla-imp-adic.val-base-icms                 at 083 
    tt-decla-imp-adic.val-icms-db-cr                at 107
   SKIP 
    "FCP:"                                          at 008 
    de-val-aliq-fcp                                 at 025  
    de-val-base-fcp                                 at 083 
    de-val-fcp                                      at 107 
   SKIP 
    "FCP ST:"                                       at 005
    de-val-aliq-fcp-substto                         at 025  
    de-val-base-fcp-substto                         at 083 
    de-val-fcp-substto                              at 107    
   SKIP 
    "ICMS ST:"                                      at 004
    de-val-base-icms-substto                        at 083
    de-val-icms-substto                             at 107
   SKIP 
    "ICMS Compl:"                                   at 001
    de-val-base-icms-compltar                       at 083
    de-val-icms-compltar                            at 107        
   SKIP(1)
    "Totais:"                                       AT 005
    d-tot-perc-reduc                                AT 047
    d-tot-val-db-cr                                 AT 107
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-impAdic.
/* fim - impostos adicao*/

     

/* despesas adicao */
FORM HEADER
     SKIP(3)
      "*" FILL("-",51) FORMAT "X(51)" "DESPESAS ADIÄ«O NR." i-num-adic FILL("-",52) FORMAT "X(52)" "*"
     SKIP
    "Despesa"                     at 002
    "Moeda"                       at 034
    "Taxa Cambio"                 at 083
    "F Pre."                      at 096
    "Tipo Despesa"                at 105
    "Incoterm"                    at 123 SKIP
    "Fornecedor"                  at 002
    "Condiá∆o Pagto"              at 034
    "Dupl"                        at 061
    "II"                          at 068
    "IPI"                         at 074
    "ICMS"                        at 080
    "PIS-ADU"                     at 087
    "PIS-DESP"                    at 096
    "CONFINS-ADU"                 at 106
    "COFINS-DESP"                 at 119 SKIP
    "Valor-ME"                    at 094
    "Valor-MN"                    at 123 SKIP
    FILL("-",130) FORMAT "X(130)" AT 002
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecDespAdic.

/* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-798) */
FORM HEADER
     SKIP(3)
      "*" FILL("-",51) FORMAT "X(51)" "DESPESAS ADIÄ«O NR." i-num-adic FILL("-",52) FORMAT "X(52)" "*"
     SKIP
    "Despesa"                     at 002
    "Moeda"                       at 034
    "Taxa Cambio"                 at 083
    "F Pre."                      at 096
    "Tipo Despesa"                at 105
    "Incoterm"                    at 123 SKIP
    "Fornecedor"                  at 002
    "Condiá∆o Pagto"              at 034
    "Dupl"                        at 061
    "II"                          at 068
    "IPI"                         at 074
    "ICMS"                        at 080
    "PIS-ADU"                     at 087
    "PIS-DESP"                    at 096
    "CONFINS-ADU"                 at 106
    "COFINS-DESP"                 at 119 SKIP
    "CBS"                         at 002
    "IBS UF"                      at 008
    "IBS Mun"                     at 018
    "Valor-ME"                    at 094
    "Valor-MN"                    at 123 SKIP
    FILL("-",130) FORMAT "X(130)" AT 002
   WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecDespAdicCbsIbs.
/* FIM - -Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-798) */

 FORM tt-despes-adic.cdn-despes                              AT 001 /*7*/
      c-desc-desp                                            AT 008 /*13*/
      c-desp-moeda                                           AT 034
      d-taxa-camb                                            AT 077
      tt-despes-adic.log-forma-preco-compra                  AT 096
      c-tipo-despes                                          AT 105
      tt-despes-adic.cod-incoterm-rat                        AT 125
     SKIP                                                    
      tt-despes-adic.cdn-emit-despes                         AT 001
      c-desc-emitente                                        AT 010
      tt-despes-adic.cdn-cond-pag                            AT 034
      c-desc-cond-pagto                                      AT 038
      l-duplic                                               AT 061
      l-ii                                                   AT 068
      l-ipi                                                  AT 074
      l-icms                                                 AT 080
      l-pis-adu                                              AT 087
      l-pis-desp                                             AT 096
      l-cofins-adu                                           AT 106
      l-cofins-desp                                          AT 119
     SKIP
      d-valor-me                                             AT 078
      d-valor-mn                                             AT 107
     SKIP(2)
    WITH DOWN WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-despAdic.
    
/* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-798) */
FORM tt-despes-adic.cdn-despes                              AT 001 /*7*/
     c-desc-desp                                            AT 008 /*13*/
     c-desp-moeda                                           AT 034
     d-taxa-camb                                            AT 077
     tt-despes-adic.log-forma-preco-compra                  AT 096
     c-tipo-despes                                          AT 105
     tt-despes-adic.cod-incoterm-rat                        AT 125
    SKIP                                                    
     tt-despes-adic.cdn-emit-despes                         AT 001
     c-desc-emitente                                        AT 010
     tt-despes-adic.cdn-cond-pag                            AT 034
     c-desc-cond-pagto                                      AT 038
     l-duplic                                               AT 061
     l-ii                                                   AT 068
     l-ipi                                                  AT 074
     l-icms                                                 AT 080
     l-pis-adu                                              AT 087
     l-pis-desp                                             AT 096
     l-cofins-adu                                           AT 106
     l-cofins-desp                                          AT 119
    SKIP
     l-cbs                                                  AT 002
     l-ibs-uf                                               AT 008
     l-ibs-mun                                              AT 018
     d-valor-me                                             AT 078
     d-valor-mn                                             AT 107
    SKIP(2)
   WITH DOWN WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-despAdicCbsIbs.
/* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-798) */

/* fim - despesas adicao */

/* cambio adicao */

FORM 
    SKIP(3)
     c-cabec-cambio-adic                                 NO-LABEL                      
    SKIP(1)
    c-pagamento                                          LABEL "Pagamento"             AT 014
    tt-decla-imp-adic.cdn-motivo                         LABEL "Motivo"                AT 084
    SKIP
    tt-decla-imp-adic.cdn-modal-pagto                    LABEL "Modalidade Pagamento"  AT 003
    tt-decla-imp-adic.log-moed-nac                       LABEL "Moeda Nacional"        AT 076
    SKIP
    c-corretor-cambio                                    LABEL "Corretor CÉmbio"       AT 008
    tt-decla-imp-adic.cod-rof                            LABEL "Nr. ROF"               AT 083
    SKIP
    c-banco                                              LABEL "Banco"                 AT 018
    tt-decla-imp-adic.cdn-praca                          LABEL "Praáa"                 AT 085
    SKIP
    tt-decla-imp-adic.cod-contrat-cambio                 LABEL "Contrato"              AT 015
    c-agente                                             LABEL "Ident. Agente"         AT 077
    SKIP
    c-banco-agente                                       LABEL "Banco Agente"          AT 011
    tt-decla-imp-adic.cod-agenc-agent                    LABEL "Agància Agente"        AT 076
   WITH WIDTH 132 SIDE-LABEL NO-BOX STREAM-IO FRAME f-cambioAdic.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cambioAdic:HANDLE).

/* fim - cambio adicao */

/* fim - definiá∆o dos forms que s¢ ser∆o utilizados por este layout (im0440a.p)*/

/*carrgar temp-tables*/
FOR EACH  tt-decla-import, 
    EACH  decla-import-adic 
    WHERE decla-import-adic.num-di-ems       = tt-decla-import.num-di-ems
      AND decla-import-adic.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts:
    IF NOT CAN-FIND(FIRST tt-decla-imp-adic
                    WHERE tt-decla-imp-adic.num-di-ems       = tt-decla-import.num-di-ems
                    AND   tt-decla-imp-adic.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                    AND   tt-decla-imp-adic.num-adic         = decla-import-adic.num-adic) THEN DO:
        CREATE tt-decla-imp-adic.
        BUFFER-COPY decla-import-adic TO tt-decla-imp-adic.
        
        /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-798) */
        IF  l-nt2024002 THEN DO:
            FOR EACH  decla-import-adic-trib NO-LOCK
                WHERE decla-import-adic-trib.num-di-ems       = tt-decla-imp-adic.num-di-ems                
                AND   decla-import-adic-trib.num-adic         = tt-decla-imp-adic.num-adic
                AND   decla-import-adic-trib.cdd-siscomex-dts = tt-decla-imp-adic.cdd-siscomex-dts:
                
                CASE decla-import-adic-trib.nom-trib:
                    WHEN "IBSUF":U THEN DO:
                        CASE decla-import-adic-trib.cod-campo:
                            WHEN "COD-TRIB":U THEN DO:
                                ASSIGN i-trib-ibsuf = INT(decla-import-adic-trib.cod-conteudo).
                                ASSIGN tt-decla-imp-adic.cod-trib-ibs-uf = {diinc/i01di628.i 04 i-trib-ibsuf}.
                            END.
                            WHEN "ALIQUOTA":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-aliq-ibs-uf = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "ALIQ-RED":U THEN DO:
                                ASSIGN tt-decla-imp-adic.perc-reduc-ibs-uf = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "BASE":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-base-ibs-uf = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "VALOR":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-ibs-uf-db-cr = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "ALIQ-EFETIVA-REG":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-aliq-ibs-uf-reg = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "BASE-REG":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-base-ibs-uf-reg = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "VALOR-REG":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-ibs-uf-reg = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                        END CASE.
                    END.
                    WHEN "IBSMUN":U THEN DO:
                        CASE decla-import-adic-trib.cod-campo:
                            WHEN "COD-TRIB":U THEN DO:
                                ASSIGN i-trib-ibsmun = INT(decla-import-adic-trib.cod-conteudo).
                                ASSIGN tt-decla-imp-adic.cod-trib-ibs-mun = {diinc/i01di628.i 04 i-trib-ibsmun}.
                            END.
                            WHEN "ALIQUOTA":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-aliq-ibs-mun = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "ALIQ-RED":U THEN DO:
                                ASSIGN tt-decla-imp-adic.perc-reduc-ibs-mun = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "BASE":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-base-ibs-mun = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "VALOR":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-ibs-mun-db-cr = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "ALIQ-EFETIVA-REG":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-aliq-ibs-mun-reg = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "BASE-REG":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-base-ibs-mun-reg = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "VALOR-REG":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-ibs-mun-reg = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                        END CASE.
                    END.
                    WHEN "CBS":U THEN DO:
                        CASE decla-import-adic-trib.cod-campo:
                            WHEN "COD-TRIB":U THEN DO:
                                ASSIGN i-trib-cbs = INT(decla-import-adic-trib.cod-conteudo).
                                ASSIGN tt-decla-imp-adic.cod-trib-cbs = {diinc/i01di628.i 04 i-trib-cbs}.
                            END.
                            WHEN "ALIQUOTA":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-aliq-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "ALIQ-RED":U THEN DO:
                                ASSIGN tt-decla-imp-adic.perc-reduc-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "BASE":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-base-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "VALOR":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-cbs-db-cr = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "ALIQ-EFETIVA-REG":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-aliq-cbs-reg = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "BASE-REG":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-base-cbs-reg = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "VALOR-REG":U THEN DO:
                                ASSIGN tt-decla-imp-adic.val-cbs-reg = DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                        END CASE.
                    END.
                END CASE.
            END.
        END.
        /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-798) */
    END.
END.

FOR EACH  tt-decla-imp-adic,
    EACH  decla-import-adic-nve
    WHERE tt-decla-imp-adic.num-di-ems       = decla-import-adic-nve.num-di-ems
    AND   tt-decla-imp-adic.cdd-siscomex-dts = decla-import-adic-nve.cdd-siscomex-dts
    AND   tt-decla-imp-adic.num-adic         = decla-import-adic-nve.num-adic:
    IF NOT CAN-FIND(FIRST tt-decla-imp-adic-nve
                        WHERE tt-decla-imp-adic-nve.num-di-ems       = decla-import-adic-nve.num-di-ems
                        AND   tt-decla-imp-adic-nve.cdd-siscomex-dts = decla-import-adic-nve.cdd-siscomex-dts
                        AND   tt-decla-imp-adic-nve.num-adic         = decla-import-adic-nve.num-adic
                        AND   tt-decla-imp-adic-nve.idi-niv          = decla-import-adic-nve.idi-niv
                        AND   tt-decla-imp-adic-nve.cod-ident        = decla-import-adic-nve.cod-ident
                        AND   tt-decla-imp-adic-nve.cod-atributo     = decla-import-adic-nve.cod-atributo
                        AND   tt-decla-imp-adic-nve.cdn-especif      = decla-import-adic-nve.cdn-especif ) THEN DO:
        CREATE tt-decla-imp-adic-nve.
        BUFFER-COPY decla-import-adic-nve TO tt-decla-imp-adic-nve.
    END.
END.

FOR EACH  tt-decla-imp-adic,
    EACH  decla-import-adic-itens
    WHERE tt-decla-imp-adic.num-di-ems       = decla-import-adic-itens.num-di-em
    AND   tt-decla-imp-adic.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts
    AND   tt-decla-imp-adic.num-adic         = decla-import-adic-itens.num-adic:
    IF NOT CAN-FIND(FIRST tt-decla-imp-adic-itens
                        WHERE tt-decla-imp-adic-itens.num-di-ems       = decla-import-adic-itens.num-di-ems
                        AND   tt-decla-imp-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts
                        AND   tt-decla-imp-adic-itens.num-adic         = decla-import-adic-itens.num-adic
                        AND   tt-decla-imp-adic-itens.num-seq          = decla-import-adic-itens.num-seq) THEN DO:
        CREATE tt-decla-imp-adic-itens.
        BUFFER-COPY decla-import-adic-itens TO tt-decla-imp-adic-itens.
    END.
END.

FOR EACH  tt-decla-imp-adic,
    EACH  despes-adic
    WHERE tt-decla-imp-adic.num-di-ems       = despes-adic.num-di-ems
    AND   tt-decla-imp-adic.cdd-siscomex-dts = despes-adic.cdd-siscomex-dts
    AND   tt-decla-imp-adic.num-adic         = despes-adic.num-adic:
    IF NOT CAN-FIND(FIRST tt-despes-adic
                        WHERE tt-despes-adic.num-di-ems       = despes-adic.num-di-ems 
                        AND   tt-despes-adic.cdd-siscomex-dts = despes-adic.cdd-siscomex-dts
                        AND   tt-despes-adic.num-adic         = despes-adic.num-adic 
                        AND   tt-despes-adic.cdn-despes       = despes-adic.cdn-despes 
                        AND   tt-despes-adic.cdn-emit-despes  = despes-adic.cdn-emit-despes) THEN DO:
        CREATE tt-despes-adic.
        BUFFER-COPY despes-adic TO tt-despes-adic.
    END.
END.
/* fim carrgar temp-tables*/


/*##################### Disp dos forms #############################*/
FOR EACH tt-decla-import:

    {imp/im0440.i2} /*disp das frames comuns em ambos os layouts (im0440a e im0440b)*/

    
    IF  CAN-FIND(FIRST tt-decla-imp-adic
                 WHERE tt-decla-imp-adic.num-di-ems       = tt-decla-import.num-di-ems
                 AND   tt-decla-imp-adic.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts) THEN DO:
   
        VIEW FRAME f-cabecAdicoes.
        FOR EACH  tt-decla-imp-adic
            WHERE tt-decla-imp-adic.num-di-ems       = tt-decla-import.num-di-ems
            AND   tt-decla-imp-adic.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts:
            ASSIGN i-num-adic = tt-decla-imp-adic.num-adic.
    
            /*busca dados do fornecedor*/
            FIND FIRST emitente
                WHERE  emitente.cod-emitente = tt-decla-imp-adic.cdn-fornec NO-LOCK NO-ERROR.
            IF  AVAIL  emitente THEN
                ASSIGN c-nome-fornec = "- " + emitente.nome-abrev
                       c-pais-fornec = emitente.pais.
    
            /*busca dados do produtor / fabricante */
            FIND FIRST emitente 
                WHERE  emitente.cod-emitente = tt-decla-imp-adic.cdn-fabrican NO-LOCK NO-ERROR.
            IF  AVAIL  emitente THEN
                ASSIGN c-nome-fabrican = "- " + emitente.nome-abrev
                       c-pais-fabrican = emitente.pais.
    
    
            IF tt-decla-imp-adic.log-mater-usado = YES THEN
                ASSIGN c-cond-mercadoria = "Material Usado".
            ELSE DO:
                IF tt-decla-imp-adic.log-mater-encomen = YES THEN
                    ASSIGN c-cond-mercadoria = "Bem sob Encomenda".
                ELSE
                    ASSIGN c-cond-mercadoria = "".
            END.
        
            FIND FIRST decla-import-ord 
                            WHERE decla-import-ord.num-di-ems       = tt-decla-import.num-di-ems
                            AND   decla-import-ord.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                            AND   decla-import-ord.num-adic   = tt-decla-imp-adic.num-adic NO-LOCK NO-ERROR.
            IF AVAIL decla-import-ord THEN
                ASSIGN c-li = decla-import-ord.cod-licenc-import WHEN decla-import-ord.cod-licenc-import <> ""
                       c-metod-valor = {cxinc/i01cx404.i 04 decla-import-ord.idi-metod-val}.
        
            FIND FIRST classif-fisc
                        WHERE classif-fisc.class-fiscal = tt-decla-imp-adic.cod-classif-fisc NO-LOCK NO-ERROR.
            IF AVAIL classif-fisc then
                ASSIGN c-classif-fisc      = string(tt-decla-imp-adic.cod-classif-fisc,"9999.99.99") + "-" + string(tt-decla-imp-adic.cdn-classif-fisc-ex,"99")
                       c-desc-classif-fisc = " - " + trim(classif-fisc.descricao)
                       c-classif-unidade   = classif-fisc.unidade.
        
            ASSIGN c-cabecAdic = "* " + FILL("-",56) + " Adiá∆o Nr.: " + string(i-num-adic) + " " + FILL("-",56) + " *".
            DISP c-cabecAdic
                 tt-decla-imp-adic.cdn-fornec
                 c-nome-fornec
                 c-pais-fornec
                 tt-decla-imp-adic.log-emite-fabrican
                 {cxinc/i03cx403.i 04 tt-decla-imp-adic.idi-ind-vincul} @ c-ind-vinc /*tt-decla-imp-adic.idi-ind-vincul*/
                 tt-decla-imp-adic.cdn-fabrican
                 c-nome-fabrican
                 c-pais-fabrican
                 SKIP(1)
                 c-classif-fisc
                 c-desc-classif-fisc             
               with frame f-adicoes1.         

             IF CAN-FIND(FIRST classif-destaq 
                            WHERE classif-destaq.class-fiscal = tt-decla-imp-adic.cod-classif-fisc) THEN DO:
             
                 VIEW FRAME f-cabecDestaqClassif.
                 FOR EACH classif-destaq
                            WHERE classif-destaq.class-fiscal = tt-decla-imp-adic.cod-classif-fisc NO-LOCK:
                     ASSIGN i-cod-destaq = classif-destaq.cod-destaq
                            c-dsl-destaq = trim(substring(classif-destaq.dsl-destaq,1,110)).
                     DISP 
                          i-cod-destaq
                          c-dsl-destaq
                         WITH FRAME f-destaqClassif.
                         DOWN WITH FRAME f-destaqClassif.
                 END.
             END.
    
             DISP
                 tt-decla-imp-adic.cdn-naladi-sist-harmon
                 tt-decla-imp-adic.cod-naladi-ncca       
                 tt-decla-imp-adic.cod-incoterm          
                 tt-decla-imp-adic.cod-nbm               
                 tt-decla-imp-adic.cod-aladi             
                 c-li
                 c-metod-valor
                 c-cond-mercadoria                
                 tt-decla-imp-adic.cod-tip-recip         
                 tt-decla-imp-adic.qtd-capac-recip       
                 tt-decla-imp-adic.val-peso-liq          
                 tt-decla-imp-adic.qtd-ncm      
                 c-classif-unidade  
               with frame f-adicoes2.         
    
             
            IF  CAN-FIND(FIRST tt-decla-imp-adic-nve 
                         WHERE tt-decla-imp-adic-nve.num-di-ems       = tt-decla-import.num-di-ems
                         AND   tt-decla-imp-adic-nve.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                         AND   tt-decla-imp-adic-nve.num-adic         = tt-decla-imp-adic.num-adic) THEN DO:        
                 VIEW FRAME f-cabecAdicNve.
                 FOR EACH tt-decla-imp-adic-nve
                        WHERE tt-decla-imp-adic-nve.num-di-ems       = tt-decla-import.num-di-ems
                        AND   tt-decla-imp-adic-nve.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                        AND   tt-decla-imp-adic-nve.num-adic         = tt-decla-imp-adic.num-adic:
                     
                     ASSIGN c-nve-nivel = {cxinc/i01cx399.i 04 tt-decla-imp-adic-nve.idi-niv}.
    
                     RUN pi-desc-atributo(INPUT  tt-decla-imp-adic-nve.idi-niv,
                                          INPUT  tt-decla-imp-adic-nve.cod-ident,
                                          INPUT  tt-decla-imp-adic-nve.cod-atributo,
                                          OUTPUT c-nve-atributo).
    
                     RUN pi-desc-especificacao(INPUT  tt-decla-imp-adic-nve.idi-niv,
                                               INPUT  tt-decla-imp-adic-nve.cod-ident,
                                               INPUT  tt-decla-imp-adic-nve.cod-atributo,
                                               INPUT  tt-decla-imp-adic-nve.cdn-especif,
                                               OUTPUT c-nve-especif).
    
                     DISP c-nve-nivel
                          c-nve-atributo
                          c-nve-especif 
                         WITH FRAME f-adicNve.
                 END.
            END.
    
            IF  tt-param.l-Litens <> NO THEN DO:
                IF  CAN-FIND(FIRST tt-decla-imp-adic-itens 
                             WHERE tt-decla-imp-adic-itens.num-di-ems       = tt-decla-import.num-di-ems
                             AND   tt-decla-imp-adic-itens.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                             AND   tt-decla-imp-adic-itens.num-adic         = tt-decla-imp-adic.num-adic) THEN DO:
                
                    VIEW FRAME f-cabecItemAdic.
                    FOR EACH tt-decla-imp-adic-itens 
                       WHERE tt-decla-imp-adic-itens.num-di-ems       = tt-decla-import.num-di-ems
                       AND   tt-decla-imp-adic-itens.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                       AND   tt-decla-imp-adic-itens.num-adic         = tt-decla-imp-adic.num-adic:
        
                        /*IF tt-decla-imp-adic-itens.cdn-moed-vucv[1] <> 0 THEN
                            ASSIGN d-val-vucv =  tt-decla-imp-adic-itens.val-vucv-me.
                        ELSE
                            ASSIGN d-val-vucv = tt-decla-imp-adic-itens.val-vucv[1].*/
                        FIND FIRST ITEM
                                WHERE ITEM.it-codigo = tt-decla-imp-adic-itens.cod-item NO-LOCK NO-ERROR.
                        ASSIGN d-val-vucv = tt-decla-imp-adic-itens.val-vucv
                               c-especificacao = "Especificaá∆o - " + SUBSTRING(tt-decla-imp-adic-itens.dsl-especif,1,100)
                               c-un = ITEM.un WHEN AVAIL ITEM
                               c-ordem-parcela = string(tt-decla-imp-adic-itens.num-ordem) + "." + string(tt-decla-imp-adic-itens.num-parcela).
                        
                        DISP tt-decla-imp-adic-itens.num-seq           
                             tt-decla-imp-adic-itens.cod-item          
                             tt-decla-imp-adic-itens.qtd-adic[1]          
                             c-un
                             tt-decla-imp-adic-itens.cdn-moed-vucv         
                             d-val-vucv
                             tt-decla-imp-adic-itens.cod-natur-operac  
                             tt-decla-imp-adic-itens.cod-embarq      
                             c-ordem-parcela       
                             c-especificacao
                            WITH FRAME f-itemAdic. 
                    END.
                END.
            END.
            
            RUN busca-desc-moeda(INPUT tt-decla-imp-adic.cdn-moeda,
                                 OUTPUT c-val-moeda).
            RUN busca-desc-moeda(INPUT tt-decla-imp-adic.cdn-moed-frete,
                                 OUTPUT c-desc-moeda-frete).
            RUN busca-desc-moeda(INPUT tt-decla-imp-adic.cdn-moed-seguro,
                                 OUTPUT c-desc-moeda-seguro).
            ASSIGN c-desc-moeda-vmle   = c-val-moeda
                   c-desc-moeda-vmld   = c-val-moeda
                   c-desc-moeda-vmcv   = c-val-moeda
                   c-desc-moeda-acresc = c-val-moeda.
            
            VIEW FRAME f-cabecValAdic.
            DISP
                c-desc-moeda-vmle
                tt-decla-imp-adic.val-vmle
                tt-decla-imp-adic.val-vmle-me[2]       
                
                c-desc-moeda-vmld
                tt-decla-imp-adic.val-vmld
                tt-decla-imp-adic.val-vmld-me[2]       
                
                c-desc-moeda-vmcv
                tt-decla-imp-adic.val-vmcv
                tt-decla-imp-adic.val-vmcv-me[2]       
                
                c-desc-moeda-frete
                tt-decla-imp-adic.val-frete
                tt-decla-imp-adic.val-frete-me[2]      
                
                c-desc-moeda-seguro
                tt-decla-imp-adic.val-seguro
                tt-decla-imp-adic.val-seguro-me[2]     
                
                c-desc-moeda-acresc
                tt-decla-imp-adic.val-acresc
                tt-decla-imp-adic.val-acresc-me[2]     
            WITH FRAME f-valAdic.
    
            /* impostos adicao */
            ASSIGN c-tributac-ii      = {cxinc/i01cx402.i 04 tt-decla-imp-adic.idi-tributac-impto-import}
                   c-tributac-ipi     = {cxinc/i01cx402.i 04 tt-decla-imp-adic.idi-tributac-ipi}
                   c-tributac-pis     = {cxinc/i01cx402.i 04 tt-decla-imp-adic.idi-tributac-pis}
                   c-tributac-cofins  = {cxinc/i01cx402.i 04 tt-decla-imp-adic.idi-tributac-cofins}
                   c-tributac-icms    = {cxinc/i01cx402.i 04 tt-decla-imp-adic.idi-tributac-icms}.
                   
            ASSIGN de-val-aliq-fcp           = 0 
                   de-val-base-fcp           = 0
                   de-val-fcp                = 0
                   de-val-aliq-fcp-substto   = 0 
                   de-val-base-fcp-substto   = 0 
                   de-val-fcp-substto        = 0
                   de-val-base-icms-substto  = 0
                   de-val-icms-substto       = 0 
                   de-val-base-icms-compltar = 0 
                   de-val-icms-compltar      = 0.
                   
            RUN pi-busca-valores-impostos IN h-bocx402 (INPUT  tt-decla-imp-adic.num-di-ems,
                                                        INPUT  tt-decla-imp-adic.num-adic,
                                                        INPUT  tt-decla-imp-adic.cdd-siscomex-dts,
                                                        OUTPUT de-val-aliq-fcp,          
                                                        OUTPUT de-val-base-fcp,          
                                                        OUTPUT de-val-fcp,               
                                                        OUTPUT de-val-aliq-fcp-substto,  
                                                        OUTPUT de-val-base-fcp-substto,  
                                                        OUTPUT de-val-fcp-substto,       
                                                        OUTPUT de-val-base-icms-substto, 
                                                        OUTPUT de-val-icms-substto,      
                                                        OUTPUT de-val-base-icms-compltar,
                                                        OUTPUT de-val-icms-compltar).
    
            ASSIGN d-tot-perc-reduc = tt-decla-imp-adic.val-perc-reduc-impto-import +
                                      tt-decla-imp-adic.val-perc-reduc-ipi          +
                                      tt-decla-imp-adic.val-perc-reduc-pis          +
                                      tt-decla-imp-adic.val-perc-reduc-cofins       +
                                      tt-decla-imp-adic.val-perc-reduc-icms
    
                   d-tot-val-db-cr  = tt-decla-imp-adic.val-ii-db-cr                +
                                      tt-decla-imp-adic.val-ipi-db-cr               +
                                      tt-decla-imp-adic.val-pis-db-cr               +
                                      tt-decla-imp-adic.val-cofins-db-cr            +
                                      tt-decla-imp-adic.val-icms-db-cr              +
                                      de-val-fcp                                    +
                                      de-val-fcp-substto                            +
                                      de-val-icms-substto                           +
                                      de-val-icms-compltar.

            VIEW FRAME f-cabecImpAdic.
            
            /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-798) */
            IF  l-nt2024002 THEN DO:
                ASSIGN d-tot-perc-reduc = d-tot-perc-reduc + (tt-decla-imp-adic.perc-reduc-ibs-uf  + 
                                                              tt-decla-imp-adic.perc-reduc-ibs-mun + 
                                                              tt-decla-imp-adic.perc-reduc-cbs)
                       d-tot-val-db-cr  = d-tot-val-db-cr  + (tt-decla-imp-adic.val-ibs-uf-db-cr  + 
                                                              tt-decla-imp-adic.val-ibs-mun-db-cr + 
                                                              tt-decla-imp-adic.val-cbs-db-cr     +
                                                              tt-decla-imp-adic.val-ibs-uf-reg    + 
                                                              tt-decla-imp-adic.val-ibs-mun-reg   + 
                                                              tt-decla-imp-adic.val-cbs-reg).
            
                DISP c-tributac-ii
                     tt-decla-imp-adic.val-aliq-ii
                     tt-decla-imp-adic.log-suspens-impto-import
                     tt-decla-imp-adic.val-perc-reduc-impto-import
                     tt-decla-imp-adic.val-unit-ii
                     tt-decla-imp-adic.val-base-ii
                     tt-decla-imp-adic.val-ii-db-cr
                     
                     c-tributac-ipi
                     tt-decla-imp-adic.val-aliq-ipi
                     tt-decla-imp-adic.log-suspens-ipi-import
                     tt-decla-imp-adic.val-perc-reduc-ipi
                     tt-decla-imp-adic.val-unit-ipi
                     tt-decla-imp-adic.val-base-ipi
                     tt-decla-imp-adic.val-ipi-db-cr
                     
                     c-tributac-pis
                     tt-decla-imp-adic.val-aliq-pis
                     tt-decla-imp-adic.val-perc-reduc-pis
                     tt-decla-imp-adic.val-unit-pis
                     tt-decla-imp-adic.val-base-pis
                     tt-decla-imp-adic.val-pis-db-cr
                     
                     c-tributac-cofins
                     tt-decla-imp-adic.val-aliq-cofins
                     tt-decla-imp-adic.val-perc-reduc-cofins
                     tt-decla-imp-adic.val-unit-cofins
                     tt-decla-imp-adic.val-base-cofins
                     tt-decla-imp-adic.val-cofins-db-cr
                     
                     c-tributac-icms
                     tt-decla-imp-adic.val-aliq-icms
                     tt-decla-imp-adic.val-perc-reduc-icms
                     tt-decla-imp-adic.val-unit-icms
                     tt-decla-imp-adic.val-base-icms
                     tt-decla-imp-adic.val-icms-db-cr
                     
                     de-val-aliq-fcp
                     de-val-base-fcp
                     de-val-fcp     
                     
                     de-val-aliq-fcp-substto
                     de-val-base-fcp-substto
                     de-val-fcp-substto 
                     
                     de-val-base-icms-substto      
                     de-val-icms-substto                                            
                     
                     de-val-base-icms-compltar     
                     de-val-icms-compltar        
                     
                     tt-decla-imp-adic.cod-trib-ibs-uf
                     tt-decla-imp-adic.val-aliq-ibs-uf
                     tt-decla-imp-adic.perc-reduc-ibs-uf
                     tt-decla-imp-adic.val-base-ibs-uf
                     tt-decla-imp-adic.val-ibs-uf-db-cr
                     
                     tt-decla-imp-adic.cod-trib-ibs-mun
                     tt-decla-imp-adic.val-aliq-ibs-mun
                     tt-decla-imp-adic.perc-reduc-ibs-mun
                     tt-decla-imp-adic.val-base-ibs-mun
                     tt-decla-imp-adic.val-ibs-mun-db-cr

                     tt-decla-imp-adic.cod-trib-cbs
                     tt-decla-imp-adic.val-aliq-cbs
                     tt-decla-imp-adic.perc-reduc-cbs
                     tt-decla-imp-adic.val-base-cbs
                     tt-decla-imp-adic.val-cbs-db-cr
                     
                     tt-decla-imp-adic.val-aliq-ibs-uf-reg
                     tt-decla-imp-adic.val-base-ibs-uf-reg
                     tt-decla-imp-adic.val-ibs-uf-reg

                     tt-decla-imp-adic.val-aliq-ibs-mun-reg
                     tt-decla-imp-adic.val-base-ibs-mun-reg
                     tt-decla-imp-adic.val-ibs-mun-reg

                     tt-decla-imp-adic.val-aliq-cbs-reg
                     tt-decla-imp-adic.val-base-cbs-reg
                     tt-decla-imp-adic.val-cbs-reg

                     d-tot-perc-reduc
                     d-tot-val-db-cr
                    WITH FRAME f-impAdicCbsIbs.
            END.
            /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-798) */
            ELSE DO:
                DISP c-tributac-ii
                     tt-decla-imp-adic.val-aliq-ii
                     tt-decla-imp-adic.log-suspens-impto-import
                     tt-decla-imp-adic.val-perc-reduc-impto-import
                     tt-decla-imp-adic.val-unit-ii
                     tt-decla-imp-adic.val-base-ii
                     tt-decla-imp-adic.val-ii-db-cr
                     
                     c-tributac-ipi
                     tt-decla-imp-adic.val-aliq-ipi
                     tt-decla-imp-adic.log-suspens-ipi-import
                     tt-decla-imp-adic.val-perc-reduc-ipi
                     tt-decla-imp-adic.val-unit-ipi
                     tt-decla-imp-adic.val-base-ipi
                     tt-decla-imp-adic.val-ipi-db-cr
                     
                     c-tributac-pis
                     tt-decla-imp-adic.val-aliq-pis
                     tt-decla-imp-adic.val-perc-reduc-pis
                     tt-decla-imp-adic.val-unit-pis
                     tt-decla-imp-adic.val-base-pis
                     tt-decla-imp-adic.val-pis-db-cr
                     
                     c-tributac-cofins
                     tt-decla-imp-adic.val-aliq-cofins
                     tt-decla-imp-adic.val-perc-reduc-cofins
                     tt-decla-imp-adic.val-unit-cofins
                     tt-decla-imp-adic.val-base-cofins
                     tt-decla-imp-adic.val-cofins-db-cr
                     
                     c-tributac-icms
                     tt-decla-imp-adic.val-aliq-icms
                     tt-decla-imp-adic.val-perc-reduc-icms
                     tt-decla-imp-adic.val-unit-icms
                     tt-decla-imp-adic.val-base-icms
                     tt-decla-imp-adic.val-icms-db-cr
                     
                     de-val-aliq-fcp
                     de-val-base-fcp
                     de-val-fcp     
                     
                     de-val-aliq-fcp-substto
                     de-val-base-fcp-substto
                     de-val-fcp-substto 
                     
                     de-val-base-icms-substto      
                     de-val-icms-substto                                            
                     
                     de-val-base-icms-compltar     
                     de-val-icms-compltar        
                     
                     d-tot-perc-reduc
                     d-tot-val-db-cr
                    WITH FRAME f-impAdic.
             END.   
            /* fim - impostos adicao */
    
            /* despesas adicao */
            IF tt-param.l-despesas-adicoes <> NO THEN DO:
    
                IF  CAN-FIND(FIRST tt-despes-adic
                             WHERE tt-despes-adic.num-di-ems       = tt-decla-import.num-di-ems
                             AND   tt-despes-adic.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                             AND   tt-despes-adic.num-adic         = tt-decla-imp-adic.num-adic) THEN DO:
                
                    /*VIEW FRAME f-cabecDespDi.*/
                    /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-798) */
                    IF  l-nt2024002 THEN DO:
                        VIEW FRAME f-cabecDespAdicCbsIbs.
                    END.
                    /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-798) */
                    ELSE DO:
                        VIEW FRAME f-cabecDespAdic.
                    END.
                    FOR EACH tt-despes-adic
                        WHERE tt-despes-adic.num-di-ems       = tt-decla-import.num-di-ems
                        AND   tt-despes-adic.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                        AND   tt-despes-adic.num-adic         = tt-decla-import.num-adic:
                        
                        FIND FIRST desp-imp NO-LOCK WHERE desp-imp.cod-desp = tt-despes-adic.cdn-despes NO-ERROR.
                        
                        FOR FIRST desp-embarque FIELDS(descricao)
                            WHERE desp-embarque.cod-estabel = tt-decla-import.cod-estab
                              AND desp-embarque.embarque = tt-despes-adic.cod-embarq
                              AND desp-embarque.cod-desp = tt-despes-adic.cdn-despes NO-LOCK: END.
                        IF AVAIL desp-imp THEN DO:
                            ASSIGN c-desc-desp   = "-" + if avail desp-embarque and desp-embarque.descricao <> "":U then desp-embarque.descricao else desp-imp.descricao
                                   l-duplic      = desp-imp.inc-val-dupli
                                   l-ii          = desp-imp.log-2
                                   l-ipi         = desp-imp.inc-base-ipi
                                   l-icms        = desp-imp.inc-base-icms
                                   l-pis-adu     = desp-imp.log-incid-base-pis-val
                                   l-pis-desp    = desp-imp.log-incid-base-pis-despes
                                   l-cofins-adu  = desp-imp.log-incid-base-cofins-val
                                   l-cofins-desp = desp-imp.log-incid-base-cofins-despes.
                                   c-tipo-despes = {cxinc/i01cx010.i 04 desp-imp.tipo}. 
                        END.
                        
                        RUN busca-desc-moeda(INPUT tt-despes-adic.cdn-moeda,
                                             OUTPUT c-desp-moeda).
                
                        FIND FIRST emitente WHERE emitente.cod-emitente = tt-despes-adic.cdn-emit-despes NO-LOCK NO-ERROR.
                        ASSIGN c-desc-emitente = "-" + emitente.nome-abrev.
                
                        FIND FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = tt-despes-adic.cdn-cond-pag NO-LOCK NO-ERROR.
                        ASSIGN c-desc-cond-pagto = "-" + cond-pagto.descricao WHEN AVAIL cond-pagto.
                                                 
                        /*converte a moeda */
                        IF tt-despes-adic.cdn-moeda <> 0 THEN DO:
                            RUN valor-cotado(INPUT  tt-despes-adic.num-di-ems,
                                             INPUT  tt-despes-adic.cdd-siscomex-dts,
                                             INPUT  tt-despes-adic.cdn-moed,
                                             INPUT  tt-decla-import.dat-di,
                                             INPUT  tt-despes-adic.val-despes,
                                             OUTPUT d-valor-cotado,
                                             OUTPUT d-cotacao).
                            ASSIGN d-valor-me  = tt-despes-adic.val-despes
                                   d-valor-mn  = d-valor-cotado
                                   d-taxa-camb = d-cotacao.
                        END.
                        ELSE DO:
                            ASSIGN d-valor-me  = 0
                                   d-valor-mn  = tt-despes-adic.val-despes
                                   d-taxa-camb = 0.
                        END.
                        /*FIM converte a moeda */
                        
                        /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-798) */
                        IF  l-nt2024002 THEN DO:
                            FIND FIRST desp-imp-trib NO-LOCK
                                WHERE  desp-imp-trib.cod-desp = tt-despes-adic.cdn-despes NO-ERROR.
                            IF  AVAIL  desp-imp-trib THEN DO:
                                ASSIGN l-ibs-uf  = desp-imp-trib.log-incide-base-IBSUF
                                       l-ibs-mun = desp-imp-trib.log-incide-base-IBSMun
                                       l-cbs     = desp-imp-trib.log-incide-base-CBS-vladu.
                            END.
                            ELSE DO:
                                ASSIGN l-ibs-uf  = NO
                                       l-ibs-mun = NO
                                       l-cbs     = NO.
                            END.
                        
                            DISP tt-despes-adic.cdn-despes                      
                                 c-desc-desp                                            
                                 c-desp-moeda 
                                 d-taxa-camb                                            
                                 tt-despes-adic.log-forma-preco-compra          
                                 c-tipo-despes                                         
                                 tt-despes-adic.cod-incoterm-rat

                                 tt-despes-adic.cdn-emit-despes                 
                                 c-desc-emitente                                        
                                 tt-despes-adic.cdn-cond-pag
                                 c-desc-cond-pagto
                                 l-duplic      
                                 l-ii          
                                 l-ipi         
                                 l-icms        
                                 l-pis-adu     
                                 l-pis-desp    
                                 l-cofins-adu  
                                 l-cofins-desp                                           
                                 
                                 l-cbs
                                 l-ibs-uf
                                 l-ibs-mun
                                 d-valor-me                                             
                                 d-valor-mn  
                               WITH FRAME f-despAdicCbsIbs.
                               DOWN WITH FRAME f-despAdicCbsIbs.
                        END.
                        ELSE DO:
                            DISP tt-despes-adic.cdn-despes                      
                                 c-desc-desp                                            
                                 c-desp-moeda 
                                 d-taxa-camb                                            
                                 tt-despes-adic.log-forma-preco-compra          
                                 c-tipo-despes                                         
                                 tt-despes-adic.cod-incoterm-rat

                                 tt-despes-adic.cdn-emit-despes                 
                                 c-desc-emitente                                        
                                 tt-despes-adic.cdn-cond-pag
                                 c-desc-cond-pagto
                                 l-duplic      
                                 l-ii          
                                 l-ipi         
                                 l-icms        
                                 l-pis-adu     
                                 l-pis-desp    
                                 l-cofins-adu  
                                 
                                 l-cofins-desp                                           
                                 d-valor-me                                             
                                 d-valor-mn  
                               WITH FRAME f-despAdic.
                               DOWN WITH FRAME f-despAdic.
                        END.
                    END.
                END.
            END.
            /* fim - despesas adicao */

            /* cambio adicao */
            FIND FIRST banco
                        WHERE banco.cod-banco = tt-decla-imp-adic.cdn-banco NO-LOCK NO-ERROR.
            ASSIGN c-desc-banco = "-" + banco.nome-banco WHEN AVAIL banco.

            FIND FIRST banco
                        WHERE banco.cod-banco = tt-decla-imp-adic.cdn-bco-agent NO-LOCK NO-ERROR.
            ASSIGN c-desc-banco-agent = "-" + banco.nome-banco WHEN AVAIL banco.

            FIND FIRST emitente
                        WHERE emitente.cod-emitente = tt-decla-imp-adic.cdn-corretor NO-LOCK NO-ERROR.
            ASSIGN c-desc-corretor = "-" + emitente.nome-abrev WHEN AVAIL emitente.

            FIND FIRST emitente
                        WHERE emitente.cod-emitente = tt-decla-imp-adic.cdn-corretor NO-LOCK NO-ERROR.
            ASSIGN c-desc-agente = "-" + emitente.nome-abrev WHEN AVAIL emitente.


            
            ASSIGN c-cabec-cambio-adic = "* " + FILL("-",53) + " C∂MBIO ADIÄ«O NR." + string(i-num-adic) + " " + FILL("-",53) + " *"
                   c-pagamento         = {cxinc/i02cx404.i 04 tt-decla-imp-adic.idi-ind-pagto}
                   c-corretor-cambio   = STRING(tt-decla-imp-adic.cdn-corretor)  + c-desc-corretor
                   c-banco             = STRING(tt-decla-imp-adic.cdn-banco)     + c-desc-banco
                   c-agente            = STRING(tt-decla-imp-adic.cdn-agent)     + c-desc-agente
                   c-banco-agente      = STRING(tt-decla-imp-adic.cdn-bco-agent) + c-desc-banco-agent.

            DISP
                 c-cabec-cambio-adic
                 c-pagamento                                          
                 tt-decla-imp-adic.cdn-motivo                      
                 tt-decla-imp-adic.cdn-modal-pagto                 
                 tt-decla-imp-adic.log-moed-nac                 
                 c-corretor-cambio
                 tt-decla-imp-adic.cod-rof                         
                 c-banco /*tt-decla-imp-adic.cod-banco*/           
                 tt-decla-imp-adic.cdn-praca                       
                 tt-decla-imp-adic.cod-contrat-cambio               
                 c-agente /*tt-decla-imp-adic.cod-agent*/          
                 c-banco-agente /*tt-decla-imp-adic.cdn-bco-agent*/
                 tt-decla-imp-adic.cod-agenc-agent
                WITH FRAME f-cambioAdic.

            /* fim - cambio adicao */
    
    
        END. /*for each tt-decla-imp-adic*/
    END. /*if can-find*/

    PAGE. /*quebra p†gina no final de cada DI*/

END. /*for each tt-decla-import*/

{imp/im0440.i3} /*imprime os parametros da busca*/

/*procedure que retorna a descriá∆o do atributo*/
PROCEDURE pi-desc-atributo:
    DEFINE INPUT PARAM   pNivel        LIKE decla-import-adic-nve.idi-niv      NO-UNDO.
    DEFINE INPUT PARAM   pCodIdent     LIKE decla-import-adic-nve.cod-ident    NO-UNDO.
    DEFINE INPUT PARAM   pCodAtributo  LIKE decla-import-adic-nve.cod-atributo NO-UNDO.
    DEFINE OUTPUT PARAM  pDescAtributo LIKE nve-atrib.des-atributo             NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx398) THEN
        RUN cxbo/bocx398.p PERSISTENT SET h-bocx398.

    RUN openQueryStatic IN h-bocx398 (INPUT 'Main':U).

    RUN goToKey IN h-bocx398 (INPUT pNivel,
                              INPUT pCodIdent,
                              INPUT pCodAtributo).
    IF RETURN-VALUE = "OK":U THEN
        RUN getCharField IN h-bocx398 (INPUT 'des-atributo',
                                       OUTPUT pDescAtributo).
    ELSE
        ASSIGN pDescAtributo = "".

    RETURN "OK".

END PROCEDURE.
/* fim - procedure que retorna a descriá∆o do atributo*/

/*procedure que retorna a descriá∆o da especificaá∆o*/
PROCEDURE pi-desc-especificacao:
    DEFINE INPUT PARAM   pNivel        LIKE decla-import-adic-nve.idi-niv      NO-UNDO.
    DEFINE INPUT PARAM   pCodIdent     LIKE decla-import-adic-nve.cod-ident    NO-UNDO.
    DEFINE INPUT PARAM   pCodAtributo  LIKE decla-import-adic-nve.cod-atributo NO-UNDO.
    DEFINE INPUT PARAM   pCodEspecif   LIKE decla-import-adic-nve.cdn-especif  NO-UNDO.
    DEFINE OUTPUT PARAM  pDescEspecif  LIKE nve-atrib.des-atributo             NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx397) THEN
        RUN cxbo/bocx397.p PERSISTENT SET h-bocx397.

    RUN openQueryStatic IN h-bocx397 (INPUT 'Main':U).

    RUN goToKey IN h-bocx397 (INPUT pNivel,
                              INPUT pCodIdent,
                              INPUT pCodAtributo,
                              INPUT pCodEspecif).
    IF RETURN-VALUE = "OK":U THEN
        RUN getCharField IN h-bocx397 (INPUT 'des-especif',
                                       OUTPUT pDescEspecif).
    ELSE
        ASSIGN pDescEspecif = "".

    RETURN "OK".

END PROCEDURE.
/* fim - procedure que retorna a descriá∆o da especificaá∆o*/


/* elimina as handles utilizadas */
IF VALID-HANDLE(h-bocx397) THEN DO:
    DELETE PROCEDURE h-bocx397.
    ASSIGN h-bocx397 = ?.
END.

IF VALID-HANDLE(h-bocx398) THEN DO:
    DELETE PROCEDURE h-bocx398.
    ASSIGN h-bocx398 = ?.
END.

IF VALID-HANDLE(h-bocx402) THEN DO:
    DELETE PROCEDURE h-bocx402.
    ASSIGN h-bocx402 = ?.
END.
/* elimina as handles utilizadas */

return 'OK'.

