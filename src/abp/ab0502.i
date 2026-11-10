{include/i_dbvers.i}
/***** Defini‡Æo da tt-param e Variÿveis******/


DEFINE BUFFER bfControlBomba FOR mab-control-bomba.
/****************** Defini‡ao de Variÿveis de Sele‡Æo do Relat¢rio *********************/ 

DEFINE VARIABLE l-Insere                      AS LOGICAL   VIEW-AS toggle-box.
DEFINE VARIABLE d-data-ini                    LIKE mab-control-bomba.dat-apont   NO-UNDO.                   
DEFINE VARIABLE d-data-fim                    LIKE mab-control-bomba.dat-apont   NO-UNDO.      
DEFINE VARIABLE c-hora-ini                    LIKE mab-control-bomba.hra-apont   NO-UNDO.     
DEFINE VARIABLE c-hora-fim                    LIKE mab-control-bomba.hra-apont   NO-UNDO.      
DEFINE VARIABLE c-bomba-ini                   LIKE mab-bomba.cod-bomba           NO-UNDO.
DEFINE VARIABLE c-bomba-fim                   LIKE mab-bomba.cod-bomba           NO-UNDO.
DEFINE VARIABLE c-posto-ini                   LIKE mab-posto.cod-posto           NO-UNDO.
DEFINE VARIABLE c-posto-fim                   LIKE mab-posto.cod-posto           NO-UNDO.
DEFINE VARIABLE i-cod-emp-ini                 LIKE mab-posto.ep-codigo           NO-UNDO.
DEFINE VARIABLE i-cod-emp-fim                 LIKE mab-posto.ep-codigo           NO-UNDO.
DEFINE VARIABLE c-leitura-bombas       AS CHARACTER format "x(43)" NO-UNDO.
DEFINE VARIABLE c-leitura-bombas-2     AS CHARACTER format "x(63)" NO-UNDO.
DEFINE VARIABLE c-soma-abastec         AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE c-soma-abastec-2       AS CHARACTER format "x(17)" NO-UNDO.
DEFINE VARIABLE c-diferenca            AS CHARACTER format "x(13)" NO-UNDO.
DEFINE VARIABLE c-posto                AS CHARACTER  FORMAT "x(08)"NO-UNDO.
DEFINE VARIABLE c-bomba                AS CHARACTER FORMAT "x(08)" NO-UNDO.
DEFINE VARIABLE c-material             AS CHARACTER FORMAT "x(08)" NO-UNDO.
DEFINE VARIABLE c-docto                AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE LabelEmp               AS CHARACTER FORMAT "x(07)" NO-UNDO.
DEFINE VARIABLE LabelIn                AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE LabelFim               AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE Labelqtde-1            AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE Labelqtde-2            AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE Labelqtde-3            AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE labelPT                AS CHARACTER FORMAT "x(07)" NO-UNDO.
DEFINE VARIABLE c-Inicial              AS dec  FORMAT ">>,>>>,>>9.99"    NO-UNDO.
DEFINE VARIABLE c-Final                AS dec  FORMAT ">>,>>>,>>9.99"    NO-UNDO.
DEFINE VARIABLE c-quantde-1            AS dec  FORMAT "->>,>>>,>>9.9"  NO-UNDO.
DEFINE VARIABLE c-quantde-2            AS dec  FORMAT "->>,>>>,>>9.9"  NO-UNDO. 
DEFINE VARIABLE c-quantde-3            AS dec  FORMAT "->>,>>>,>>9.9"  NO-UNDO.
DEFINE VARIABLE c-ptgem                AS dec  FORMAT "->>9.99"        NO-UNDO.
DEFINE VARIABLE c-texto-1              AS CHARACTER  FORMAT "x(20)"         NO-UNDO.
DEFINE VARIABLE c-data                 AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-hora                 AS CHARACTER FORMAT "x(08)"  NO-UNDO.
DEFINE VARIABLE c-data-2               AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-data-3               AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-docto-2              AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-title                AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-total-1              AS dec  FORMAT "->>,>>9.99"  NO-UNDO.
DEFINE VARIABLE c-total-2              AS dec  FORMAT "->,>>>,>>9.99"  NO-UNDO.
DEFINE VARIABLE c-total-3              AS dec  FORMAT "->,>>>,>>9.99"  NO-UNDO.
DEFINE VARIABLE c-total-4              AS dec  FORMAT "->,>>9.99"  NO-UNDO.
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE VARIABLE cEmp                   LIKE empresa.ep-codigo  NO-UNDO.
&ELSE
DEFINE VARIABLE cEmp                   AS INT  NO-UNDO.
&ENDIF
DEFINE VARIABLE cPosto                 AS CHARACTER FORMAT "x(06)" NO-UNDO.
DEFINE VARIABLE cBomba                 AS CHARACTER FORMAT "x(08)" NO-UNDO.
DEFINE VARIABLE cTpMater               AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE iNumDoc                AS INT  NO-UNDO.
DEFINE VARIABLE l-first                AS LOGICAL   INIT NO NO-UNDO.
define variable dHoraInvert            LIKE mab-control-bomba.val-dat-hora-invrtda NO-UNDO.
DEFINE VARIABLE iDocto                 LIKE  mab-item-abastec.num-docto   NO-UNDO.
DEFINE VARIABLE dValQtde               AS dec  FORMAT "->,>>>,>>9.99"  NO-UNDO.

/****************************************************************************************************/

/****************** Defini‡ao de Variÿveis p/ Campos Virtuais do Relat¢rio *******************/

DEFINE VARIABLE h-acomp              as handle  NO-UNDO.
DEFINE VARIABLE v-cod-destino-impres as CHARACTER    NO-UNDO.
DEFINE VARIABLE v-num-reg-lidos      as int     NO-UNDO.
DEFINE VARIABLE v-num-point          as int     NO-UNDO.
DEFINE VARIABLE v-num-set            as int     NO-UNDO.
DEFINE VARIABLE v-num-linha          as int     NO-UNDO.
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE VARIABLE i-ep-codigo-usuario  LIKE empresa.ep-codigo     NO-UNDO.
&ELSE
DEFINE VARIABLE i-ep-codigo-usuario  as int     NO-UNDO.
&ENDIF
DEFINE VARIABLE l-imprime            as LOGICAL NO-UNDO.

def temp-table tt-raw-digita
    field raw-digita as raw.

form LabelEmp
     mab-posto.ep-codigo NO-LABEL
     " - "
     empresa.nome NO-LABEL
     with  no-box  width 132 side-labels frame f-emp-res stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-emp-res:HANDLE).


{utp/ut-liter.i Empresa * R }
assign  LabelEmp:label in frame  f-emp-res = trim(return-value).

form LabelEmp AT 01
     mab-posto.ep-codigo NO-LABEL
     " - "
     empresa.nome NO-LABEL SKIP
     mab-posto.cod-posto
     " - "
     mab-posto.des-posto NO-LABEL SKIP
     mab-bomba.cod-bomba
     with  no-box  width 132 side-labels frame f-posto-res stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-posto-res:HANDLE).


{utp/ut-liter.i Empresa * R }
assign  LabelEmp:label in frame  f-posto-res = trim(return-value).

form LabelEmp AT 02
     mab-posto.ep-codigo NO-LABEL
     " - " AT 36
     empresa.nome NO-LABEL SKIP
     mab-posto.cod-posto 
     " - "       AT 36        
     mab-posto.des-posto NO-LABEL SKIP
     mab-bomba.cod-bomba SKIP
     mab-bomba.cod-tip-mater AT 01
     " - " AT 36
     mab-tip-mater.des-tip-mater NO-LABEL
     with  no-box  width 132 side-labels frame f-bomba-res stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-bomba-res:HANDLE).


{utp/ut-liter.i Empresa * R }
assign  LabelEmp:label in frame  f-bomba-res = trim(return-value).

FORM c-leitura-bombas AT 30
     c-soma-abastec-2 AT 89
     c-diferenca      AT 110 SKIP
     c-posto          AT 01
     c-bomba          AT 10
     c-material       AT 18
     c-data           AT 28
     c-docto          AT 39
     LabelIn          AT 49
     LabelFim         AT 63
     Labelqtde-1      AT 77
     Labelqtde-2      AT 91
     Labelqtde-3      AT 105
     labelPT          AT 120
     with no-box PAGE-TOP width 132 frame f-cabecalho-res-1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cabecalho-res-1:HANDLE).


FORM mab-posto.cod-posto         AT 01
     mab-bomba.cod-bomba         AT 10
     mab-bomba.cod-tip-mater     AT 18
     mab-control-bomba.dat-apont AT 28
     mab-control-bomba.num-docto AT 39
     c-Inicial                   AT 49
     c-Final                     AT 63
     c-quantde-1                 AT 77
     c-quantde-2                 AT 91
     c-quantde-3                 AT 105
     c-ptgem                     AT 119
     with no-box NO-LABEL width 132 frame f-resumido-1 STREAM-IO.

{utp/ut-liter.i Posto * R }
assign  c-posto:label in frame f-cabecalho-res-1 = trim(return-value).
{utp/ut-liter.i Bomba * R }
assign  c-bomba:label in frame f-cabecalho-res-1 = trim(return-value).
{utp/ut-liter.i Material * R }
assign  c-material:label in frame f-cabecalho-res-1 = trim(return-value).
{utp/ut-liter.i Data * R }
assign  c-data:label in frame f-cabecalho-res-1 = trim(return-value).
{utp/ut-liter.i Documento * R }
assign  c-docto:label in frame f-cabecalho-res-1 = trim(return-value).
{utp/ut-liter.i Inicial * R }
assign  LabelIn:label in frame f-cabecalho-res-1 = trim(return-value).
{utp/ut-liter.i Final * R }
assign    LabelFim:label in frame f-cabecalho-res-1 = trim(return-value).
{utp/ut-liter.i Diferen‡a * R }
assign    Labelqtde-1:label in frame f-cabecalho-res-1 = trim(return-value).
{utp/ut-liter.i Quantidade * R }
assign    Labelqtde-2:label in frame f-cabecalho-res-1 = trim(return-value).
{utp/ut-liter.i Quantidade * R }
assign    Labelqtde-3:label in frame f-cabecalho-res-1 = trim(return-value).
{utp/ut-liter.i --_%_-- * R }
assign    labelPT:label in frame f-cabecalho-res-1 = trim(return-value).
{utp/ut-liter.i --------------------_LEITURA_BOMBAS_---------------------- * R }
assign    c-leitura-bombas:label in frame f-cabecalho-res-1 = trim(return-value).
{utp/ut-liter.i -_TOTAL_SAIDAS_- * R }
assign    c-soma-abastec-2:label in frame f-cabecalho-res-1 = trim(return-value).
{utp/ut-liter.i ----_DIFEREN€A_--------- * R }
assign    c-diferenca:label in frame f-cabecalho-res-1 = trim(return-value).

FORM mab-bomba.cod-tip-mater     AT 01
     mab-control-bomba.num-docto AT 11
     mab-control-bomba.dat-apont AT 21
     mab-control-bomba.hra-apont AT 32
     c-Inicial                   AT 41
     c-Final                     AT 55
     c-quantde-1                 AT 69
     c-quantde-2                 AT 83
     c-quantde-3                 AT 97
     c-ptgem                     AT 111
     with no-box NO-LABEL width 132 frame f-resumido-2 STREAM-IO.

FORM c-leitura-bombas-2 AT 18
     c-soma-abastec-2   AT 89                                                 
     c-diferenca        AT 109 SKIP
     c-material         AT 01 
     c-docto            AT 11 
     c-data             AT 21 
     c-hora             AT 32 
     LabelIn            AT 41 
     LabelFim           AT 55 
     Labelqtde-1        AT 69 
     Labelqtde-2        AT 83 
     Labelqtde-3        AT 97 
     labelPT            AT 111
     with no-box  width 132 frame f-cabecalho-res-2 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cabecalho-res-2:HANDLE).


{utp/ut-liter.i Material * R }
assign  c-material:label in frame f-cabecalho-res-2 = trim(return-value).
{utp/ut-liter.i Documento * R }
assign  c-docto:label in frame f-cabecalho-res-2 = trim(return-value).
{utp/ut-liter.i Inicial * R }
assign  LabelIn:label in frame f-cabecalho-res-2 = trim(return-value).
{utp/ut-liter.i Final * R }
assign    LabelFim:label in frame f-cabecalho-res-2 = trim(return-value).
{utp/ut-liter.i Quantidade * R }
assign    Labelqtde-1:label in frame f-cabecalho-res-2 = trim(return-value).
{utp/ut-liter.i Quantidade * R }
assign    Labelqtde-2:label in frame f-cabecalho-res-2 = trim(return-value).
{utp/ut-liter.i Quantidade * R }
assign    Labelqtde-3:label in frame f-cabecalho-res-2 = trim(return-value).
{utp/ut-liter.i ---_%_--- * R }
assign    labelPT:label in frame f-cabecalho-res-2 = trim(return-value).
{utp/ut-liter.i --------------------------_LEITURA_BOMBAS_------------------------- * R }
assign    c-leitura-bombas-2:label in frame f-cabecalho-res-2 = trim(return-value).
{utp/ut-liter.i -_TOTAL_SAIDAS_- * R }
assign    c-soma-abastec-2:label in frame f-cabecalho-res-2 = trim(return-value).
{utp/ut-liter.i ----_DIFEREN€A_--------- * R }
assign    c-diferenca:label in frame f-cabecalho-res-2 = trim(return-value).
{utp/ut-liter.i Data * R }
assign  c-data:label in frame f-cabecalho-res-2 = trim(return-value).
{utp/ut-liter.i Hora * R }
assign  c-hora:label in frame f-cabecalho-res-2 = trim(return-value).

FORM mab-control-bomba.num-docto AT 01
     mab-control-bomba.dat-apont AT 18 
     mab-control-bomba.hra-apont AT 29
     c-Inicial                   AT 38                    
     c-Final                       
     c-quantde-1                 AT 73                 
     c-quantde-2                 AT 92             
     c-quantde-3                 AT 106             
     c-ptgem                     TO 131
     with no-box NO-LABEL width 132 frame f-resumido-3 stream-io.

form c-leitura-bombas-2 AT 01                                                 
     c-soma-abastec-2   AT 89                                                 
     c-diferenca        AT 109 SKIP                                           
     c-docto            AT 01                                                             
     c-data             AT 18                                                                 
     c-hora             AT 29                                                                  
     LabelIn            AT 42                                                            
     LabelFim           AT 56                                                            
     Labelqtde-1        AT 75                                                            
     Labelqtde-2        AT 95                                                            
     Labelqtde-3        AT 109                                                           
     labelPT            TO 131
    with no-box  width 132 frame f-cabecalho-res-3 stream-io. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cabecalho-res-3:HANDLE).
   

{utp/ut-liter.i Documento * R }
assign  c-docto:label in frame f-cabecalho-res-3 = trim(return-value).
{utp/ut-liter.i Inicial * R }
assign  LabelIn:label in frame f-cabecalho-res-3 = trim(return-value).
{utp/ut-liter.i Final * R }
assign    LabelFim:label in frame f-cabecalho-res-3 = trim(return-value).
{utp/ut-liter.i Quantidade * R }
assign    Labelqtde-1:label in frame f-cabecalho-res-3 = trim(return-value).
{utp/ut-liter.i Quantidade * R }
assign    Labelqtde-2:label in frame f-cabecalho-res-3 = trim(return-value).
{utp/ut-liter.i Quantidade * R }
assign    Labelqtde-3:label in frame f-cabecalho-res-3 = trim(return-value).
{utp/ut-liter.i ---_%_--- * R }
assign    labelPT:label in frame f-cabecalho-res-3 = trim(return-value).
{utp/ut-liter.i --------------------------_LEITURA_BOMBAS_------------------------------------------  * R }
assign    c-leitura-bombas-2:label in frame f-cabecalho-res-3 = trim(return-value).
{utp/ut-liter.i -_TOTAL_SAIDAS_- * R }
assign    c-soma-abastec-2:label in frame f-cabecalho-res-3 = trim(return-value).
{utp/ut-liter.i ----_DIFEREN€A_--------- * R }
assign    c-diferenca:label in frame f-cabecalho-res-3 = trim(return-value).
{utp/ut-liter.i Data * R }
assign  c-data:label in frame f-cabecalho-res-3 = trim(return-value).
{utp/ut-liter.i Hora * R }
assign  c-hora:label in frame f-cabecalho-res-3 = trim(return-value).


form LabelEmp                AT 02 
     mab-posto.ep-codigo     AT 30 NO-LABEL 
     "-"                           
     empresa.nome                  NO-LABEL SKIP     
     mab-posto.cod-posto     AT 01 
     "-"                     AT 34 
     mab-posto.des-posto           NO-LABEL SKIP     
     mab-bomba.cod-bomba     AT 01 SKIP
     mab-bomba.cod-tip-mater AT 01 
     "-"                     AT 34 
     mab-tip-mater.des-tip-mater   NO-LABEL
     with  no-box PAGE-TOP width 132 side-labels frame f-detalhe-1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-detalhe-1:HANDLE).


{utp/ut-liter.i Empresa * R }
assign  LabelEmp:label in frame  f-detalhe-1 = trim(return-value).

form c-leitura-bombas-2 AT 01
     c-soma-abastec     AT 69
     c-diferenca        AT 109 SKIP
     c-data             AT 01
     c-hora             AT 12
     c-docto            AT 21 
     LabelIn            AT 32  
     LabelFim           AT 46  
     Labelqtde-1        AT 60
     c-data-2           AT 75
     c-docto-2          AT 87
     Labelqtde-2        AT 98
     Labelqtde-3        AT 113
     labelPT            TO 133
    with no-box PAGE-TOP width 133 frame f-cab-det-1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-det-1:HANDLE).


 
{utp/ut-liter.i Documento * R }
assign  c-docto:label in frame f-cab-det-1 = trim(return-value).
{utp/ut-liter.i Inicial * R }
assign  LabelIn:label in frame f-cab-det-1 = trim(return-value).
{utp/ut-liter.i Final * R }
assign    LabelFim:label in frame f-cab-det-1 = trim(return-value).
{utp/ut-liter.i Quantidade * R }
assign    Labelqtde-1:label in frame f-cab-det-1 = trim(return-value).
{utp/ut-liter.i Quantidade * R }
assign    Labelqtde-2:label in frame f-cab-det-1 = trim(return-value).
{utp/ut-liter.i Quantidade * R }
assign    Labelqtde-3:label in frame f-cab-det-1 = trim(return-value).
{utp/ut-liter.i ---_%_--- * R }
assign    labelPT:label in frame f-cab-det-1 = trim(return-value).
{utp/ut-liter.i --------------------------_LEITURA_BOMBAS_------------------------- * R }
assign    c-leitura-bombas-2:label in frame f-cab-det-1 = trim(return-value).
{utp/ut-liter.i -------_TOTAL_SAIDAS_------------- * R }
assign    c-soma-abastec:label in frame f-cab-det-1 = trim(return-value).
{utp/ut-liter.i -------_DIFEREN€A_----- * R }
assign    c-diferenca:label in frame f-cab-det-1 = trim(return-value).
{utp/ut-liter.i Data * R }
assign  c-data:label in frame f-cab-det-1 = trim(return-value).
{utp/ut-liter.i Hora * R }
assign  c-hora:label in frame f-cab-det-1 = trim(return-value).
{utp/ut-liter.i Data * R }
assign  c-data-2:label in frame f-cab-det-1 = trim(return-value).
{utp/ut-liter.i Documento * R }
assign  c-docto-2:label in frame f-cab-det-1 = trim(return-value).



form c-title   AT 60
     c-total-2 AT 97 
     c-total-3 AT 110
     c-total-4 AT 124
     with   no-box  NO-LABEL width 132 frame f-total-1 stream-io.


{utp/ut-liter.i TOTAL_---> * R }
assign   c-title = trim(return-value).



 form mab-control-bomba.dat-apont
      mab-control-bomba.hra-apont
      mab-control-bomba.num-docto
      c-Inicial    
      c-Final                    
      c-quantde-1                
      c-data-3    AT 73          
      iDocto      AT 85          
      dValQtde    AT 97
      with no-box NO-LABEL width 132 frame f-detalhe stream-io.


def temp-table tt-comp-folh
    field seq-de-imp as int
    field cd-comp   as CHARACTER
    field cd-folha  as CHARACTER.


/* Fim do Include */
DEFINE temp-table tt-param
    field destino              as integer
    field arquivo              as char
    field usuario              as char
    field data-exec            as date
    field hora-exec            as integer
    field parametro            as logical
    FIELD formato              as integer
    field v_num_tip_aces_usuar as integer
&IF "{&mguni_version}" >= "2.071" &THEN
    field i-ep-codigo          LIKE empresa.ep-codigo
&ELSE
    field i-ep-codigo          as integer
&ENDIF
    field classifica           as integer
    field desc-classifica      as char format "x(40)"
    field rs-considera         as integer
    field desc-considera       as char format "x(40)"
    field l-Insere             as logical 
    field d-data-ini           like mab-control-bomba.dat-apont
    field d-data-fim           like mab-control-bomba.dat-apont
    field c-hora-ini           like mab-control-bomba.hra-apont
    field c-hora-fim           like mab-control-bomba.hra-apont
    field c-bomba-ini          like mab-bomba.cod-bomba
    field c-bomba-fim          like mab-bomba.cod-bomba
    field c-posto-ini          like mab-posto.cod-posto
    field c-posto-fim          like mab-posto.cod-posto
    field i-cod-emp-ini        like mab-posto.ep-codigo
    field i-cod-emp-fim        like mab-posto.ep-codigo
    FIELD c-cod-estabel-ini    LIKE mab-eqpto.cod-estabel
    FIELD c-cod-estabel-fim    LIKE mab-eqpto.cod-estabel.

def temp-table tt-digita NO-UNDO
    field linha      as INTEGER
    field conteudo   as CHARACTER format "x(80)"
    index editor-id is primary unique linha.
