{include/i_dbvers.i}
/* Defini‡Æo da tt-param */
 
{cdp/cdcfgmnt.i}
def  var l-EqptosMot      as logical format "Sim/NÆo"  view-as toggle-box.
def  var l-EqptosNMot     as logical format "Sim/NÆo"  view-as toggle-box.
def  var l-EqptosAtivos   as logical format "Sim/NÆo"  view-as toggle-box.
def  var l-EqptosInativos as logical format "Sim/NÆo"  view-as toggle-box.
def  var l-EqptosProp     as logical format "Sim/NÆo"  view-as toggle-box.
def  var l-EqptosTerc     as logical format "Sim/NÆo"  view-as toggle-box.
def  var l-EventNEn       as logical format "Sim/NÆo"  view-as toggle-box.
def  var l-EventEncerr    as logical format "Sim/NÆo"  view-as toggle-box.
def  var l-ManutOleo      as logical format "Sim/NÆo"  view-as toggle-box.
def  var l-ManutFiltros   as logical format "Sim/NÆo"  view-as toggle-box.
def  var l-ManutMec       as logical format "Sim/NÆo"  view-as toggle-box.
def  var l-Custos         as logical format "Sim/NÆo"  view-as toggle-box.
def  var l-Outros         as logical format "Sim/NÆo"  view-as toggle-box.
def  var l-insere         as logical format "Sim/NÆo"  view-as toggle-box.
 
/****************** Defini‡Æo de Vari veis de Sele‡Æo do Relat¢rio *********************/ 

&IF "{&mguni_version}" >= "2.071" &THEN
def  var c-estabelec-ini      like mab-eqpto.cod-estabel                format "x(05)"      initial "" no-undo.
&ELSE
def  var c-estabelec-ini      like mab-eqpto.cod-estabel                format "x(3)"      initial "" no-undo.
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
def  var c-estabelec-fim      like mab-eqpto.cod-estabel                format "x(05)"      initial "ZZZZZ" no-undo.
&ELSE
def  var c-estabelec-fim      like mab-eqpto.cod-estabel                format "x(3)"      initial "ZZZ" no-undo.
&ENDIF
def  var c-eqpto-ini          like mab-eqpto.cod-eqpto                  format "x(16)"     initial "" no-undo.
def  var c-eqpto-fim          like mab-eqpto.cod-eqpto                  format "x(16)"     initial "ZZZZZZZZ" no-undo.
def  var c-grupo-fim          like mab-eqpto.cod-grp-eqpto              format "x(8)"      initial "" no-undo.
def  var c-grupo-ini          like mab-eqpto.cod-grp-eqpto              format "x(8)"      initial "ZZZZZZZZZZZZZZZZ" no-undo.
def  var c-modelo-fim         like mab-eqpto.cod-model                  format "x(8)"      initial "" no-undo.
def  var c-modelo-ini         like mab-eqpto.cod-model                  format "x(8)"      initial "ZZZZZZZZ" no-undo.
def  var c-tag-fim            like mab-eqpto.cd-tag                     format "x(16)"     initial "" no-undo.
def  var c-tag-ini            like mab-eqpto.cd-tag                     format "x(16)"     initial "ZZZZZZZZZZZZZZZZ" no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def  var c-empresa-ini        like mab-eqpto.ep-codigo                  format "x(03)"       initial "" no-undo.
&ELSE
def  var c-empresa-ini        like mab-eqpto.ep-codigo                  format ">>9"       initial "" no-undo.
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
def  var c-empresa-fim        like mab-eqpto.ep-codigo                  format "x(03)"       initial "ZZZ" no-undo.
&ELSE
def  var c-empresa-fim        like mab-eqpto.ep-codigo                  format ">>9"       initial 999 no-undo.
&ENDIF
def  var c-estrut-mec-ini     like mab-eqpto.cod-estrut-mec             format "x(8)"      initial "" no-undo.
def  var c-estrut-mec-fim     like mab-eqpto.cod-estrut-mec             format "x(8)"      initial "ZZZZZZZZ" no-undo.
def  var c-custo-ini          like mab-eqpto.cc-codigo                  format "x(20)"      initial "" no-undo.
def  var c-custo-fim          like mab-eqpto.cc-codigo                  format "x(20)"      initial "ZZZZZZZZZZZZZZZZZZZZ" no-undo.
def  var c-evento-ini         like mab-movto-event.cod-evento           format "x(8)"      initial "" no-undo.
def  var c-evento-fim         like mab-movto-event.cod-evento           format "x(8)"      initial "ZZZZZZZZ" no-undo.
def  var c-sub-sist-fim       like mab-movto-event.cod-sub-sist         format "x(8)"      initial "ZZZZZZZZ" no-undo.         
def  var c-sub-sist-ini       like mab-movto-event.cod-sub-sist         format "x(8)"      initial "" no-undo.                 
def  var c-manut-ini          like mab-movto-event.cd-tipo              format ">>,>>9"    initial "" no-undo. 
def  var c-manut-fim          like mab-movto-event.cd-tipo              format ">>,>>9"    initial 99999 no-undo.                 
def  var d-dat-inicial-ini    like mab-movto-event.dat-inicial          format  99/99/9999 initial TODAY no-undo.     
def  var d-dat-inicial-fim    like mab-movto-event.dat-inicial          format 99/99/9999  initial  12/31/9999  no-undo.                 
def  var d-dat-final-ini      like mab-movto-event.dat-final            format  99/99/9999 initial TODAY  no-undo.           
def  var d-dat-final-fim      like mab-movto-event.dat-final            format 99/99/9999  initial 12/31/9999  no-undo. 
&IF "{&mguni_version}" >= "2.071" &THEN
DEF  VAR c-empresa-matr-ini   LIKE mab-movto-event.ep-codigo-matr       format "x(03)"       INITIAL ""      NO-UNDO. 
&ELSE
DEF  VAR c-empresa-matr-ini   LIKE mab-movto-event.ep-codigo-matr       FORMAT ">>9"       INITIAL ""      NO-UNDO. 
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
DEF  VAR c-empresa-matr-fim   LIKE mab-movto-event.ep-codigo-matr       format "x(03)"       initial "ZZZ"     NO-UNDO. 
&ELSE
DEF  VAR c-empresa-matr-fim   LIKE mab-movto-event.ep-codigo-matr       FORMAT ">>9"       INITIAL 999     NO-UNDO. 
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
DEF  VAR c-estabel-matr-ini   LIKE mab-movto-event.cod-estabel-matr     format "x(05)"     INITIAL ""      NO-UNDO. 
&ELSE
DEF  VAR c-estabel-matr-ini   LIKE mab-movto-event.cod-estabel-matr     FORMAT "x(03)"     INITIAL ""      NO-UNDO. 
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
DEF  VAR c-estabel-matr-fim   LIKE mab-movto-event.cod-estabel-matr     format "x(05)"     INITIAL "ZZZZZ"   NO-UNDO. 
&ELSE
DEF  VAR c-estabel-matr-fim   LIKE mab-movto-event.cod-estabel-matr     FORMAT "x(03)"     INITIAL "ZZZ"     NO-UNDO. 
&ENDIF
def  var c-cod-matr-ini       like mab-movto-event.cod-matr             format  "x(10)"     initial ""         no-undo.
def  var c-cod-matr-fim       like mab-movto-event.cod-matr             format  "x(10)"     initial "ZZZZZZZZ" no-undo.
def  var c-cod-unid-negoc-ini as character format "x(03)"                                                      no-undo.
def  var c-cod-unid-negoc-fim as character format "x(03)"                                                      no-undo.
def  var c-liter-un           as character FORMAT "x(16)"                                                      NO-UNDO.
def  var cFaixa               as character FORMAT "x(05)" INITIAL "|< >|"                                      NO-UNDO.
DEFINE VARIABLE c-modelo      AS CHARACTER                              NO-UNDO.
DEFINE VARIABLE cEquipamento  AS CHARACTER      FORMAT "x(12)"          NO-UNDO.
DEFINE VARIABLE c-data        AS CHARACTER                              NO-UNDO.
DEFINE VARIABLE c-evento      AS CHARACTER                              NO-UNDO.
DEFINE VARIABLE cSubSistema   AS CHARACTER      FORMAT "x(12)"          NO-UNDO.
DEFINE VARIABLE cEstabelecimento AS CHARACTER   FORMAT "x(16)"          NO-UNDO.
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE VARIABLE iEmp          LIKE empresa.ep-codigo                    NO-UNDO.
&ELSE
DEFINE VARIABLE iEmp          AS INTEGER  FORMAT ">>9"                  NO-UNDO.
&ENDIF
DEFINE VARIABLE cEqpto        AS CHARACTER FORMAT "x(16)"               NO-UNDO.
DEFINE VARIABLE cEvento       AS CHARACTER FORMAT "x(27)"               NO-UNDO.
DEFINE VARIABLE cSubSist      AS CHARACTER FORMAT "x(30)"               NO-UNDO.
DEFINE VARIABLE cCCCodigo     AS CHARACTER FORMAT "x(8)"                NO-UNDO.
DEFINE VARIABLE iDoc          LIKE mab-movto-event.num-docto            NO-UNDO.
DEFINE VARIABLE dInicial      AS DATE FORMAT 99/99/9999                 NO-UNDO.
DEFINE VARIABLE dFinal        AS DATE FORMAT 99/99/9999                 NO-UNDO.
DEFINE VARIABLE iValor        AS INTEGER FORMAT ">>>,>>>,>>9.99"        NO-UNDO.
DEFINE VARIABLE cDescEqpto    AS CHARACTER  FORMAT "x(27)"              NO-UNDO.
DEFINE VARIABLE cDescSubSist  LIKE mab-sub-sist.des-sub-sist            NO-UNDO.
DEFINE VARIABLE cUnidNegoc    AS CHARACTER FORMAT "x(10)"               NO-UNDO.

def  var c-traco              as character format "x(76)"           no-undo.
def  var l-primeira           as logical                            no-undo.
DEFINE VARIABLE cControle    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dDataAnt     AS DATE       NO-UNDO.
/****************************************************************************************************/


/****************** Defini‡Æo de Vari veis p/ Campos Virtuais do Relat¢rio *******************/ 

def  var c-traco-1            as char    no-undo.
def  var h-acomp              as handle  no-undo.
def  var v-cod-destino-impres as char    no-undo.
def  var v-num-reg-lidos      as int     no-undo.
def  var v-num-point          as int     no-undo.
def  var v-num-set            as int     no-undo.
def  var v-num-linha          as int     no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def  var i-ep-codigo-usuario  LIKE empresa.ep-codigo     no-undo.
&ELSE
def  var i-ep-codigo-usuario  as int     no-undo.
&ENDIF
def  var l-imprime            as LOGICAL no-undo.

def temp-table tt-raw-digita
    field raw-digita as raw.

form c-modelo
     mab-model.cod-model NO-LABEL
     " - "
     mab-model.des-model no-label skip(1)
     with no-box  width 132 side-labels frame f-modelo stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-modelo:HANDLE).


{utp/ut-liter.i Modelo * R }
assign  c-modelo:label in frame f-modelo = trim(return-value).

form  cEquipamento           AT 01
      mab-eqpto.ep-codigo      no-label
       " - "                 
      mab-eqpto.cod-eqpto      no-label   
      " - "                   
      mab-model.des-model      no-label skip(1)
     with no-box  width 132 side-labels frame f-equipto stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-equipto:HANDLE).


{utp/ut-liter.i Equipamento * R }
assign  cEquipamento:label in frame f-equipto = trim(return-value).

form cEstabelecimento
     mab-eqpto.cod-estabel   NO-LABEL 
     " - "
     estabelec.nome       no-label skip(1)
     with no-box  width 132 side-labels frame f-estab stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-estab:HANDLE).


{utp/ut-liter.i Estabelecimento * R }
assign  cEstabelecimento:label in frame f-estab = trim(return-value).

form     c-evento            
         mab-movto-event.cod-evento  no-label 
         " - "      
         mab-event.des-evento no-label skip(1)  
       with no-box  width 132 side-labels frame f-evento stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-evento:HANDLE).


{utp/ut-liter.i Evento * R }
assign  c-evento:label in frame f-evento = trim(return-value).

form c-data
     mab-movto-event.dat-inicial NO-LABEL
    with no-box width 132 side-labels frame f-data stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-data:HANDLE).


{utp/ut-liter.i Data * R }
assign  c-data:label in frame f-data = trim(return-value).

form  cSubSistema 
      mab-movto-event.cod-sub-sist no-label 
      " - " 
      cDescSubSist                 no-label skip(1)
      with no-box  width 132 side-labels frame f-subsist stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-subsist:HANDLE).


{utp/ut-liter.i Sub-Sistema * R }
assign  cSubSistema:label in frame f-subsist = trim(return-value).

&IF DEFINED(bf_mnt_ems206b) &THEN
DO:
form  cUnidNegoc AT 01
      mab-movto-event.cod-unid-negoc no-label 
      " - " 
      unid-negoc.des-unid-negoc      no-label skip(1)
      with no-box  width 132 side-labels frame f-unid-negoc stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-unid-negoc:HANDLE).

END. 

{utp/ut-liter.i Unid_Negoc * R }
assign cUnidNegoc:label in frame f-unid-negoc = trim(return-value).
&ENDIF

form iEmp      
     cEqpto    
     cEvento   
     cSubSist  
     iDoc     
     dInicial  
     dFinal    
     iValor     
     with no-box width 132 64 down centered frame f-resumido1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido1:HANDLE).



{utp/ut-liter.i Evento * R }
assign  cEvento:label in frame f-resumido1 = trim(return-value).
{utp/ut-liter.i Subsistema}
assign cSubSist:label in frame f-resumido1 = trim(return-value).
{utp/ut-liter.i Execu‡Æo * R }
assign  dFinal  :label in frame f-resumido1 = trim(return-value).
{utp/ut-liter.i Emp}
assign  iEmp:label in frame f-resumido1 = trim(return-value).
{utp/ut-liter.i Abertura}
assign  dInicial:label in frame f-resumido1 = trim(return-value).
{utp/ut-liter.i Valor}
assign   iValor:label in frame f-resumido1 = trim(return-value).
{utp/ut-liter.i Equipamento }
assign   cEqpto:label in frame f-resumido1 = trim(return-value).

form iEmp      
     cEqpto    
     cDescEqpto   
     cSubSist  
     iDoc     
     dInicial  
     dFinal    
     iValor     
     with no-box width 132 64 down centered frame f-resumido3 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido3:HANDLE).



{utp/ut-liter.i Subsistema}
assign cSubSist:label in frame f-resumido3 = trim(return-value).
{utp/ut-liter.i Execu‡Æo * R }
assign  dFinal  :label in frame f-resumido3 = trim(return-value).
{utp/ut-liter.i Emp}
assign  iEmp:label in frame f-resumido3 = trim(return-value).
{utp/ut-liter.i Abertura}
assign  dInicial:label in frame f-resumido3 = trim(return-value).
{utp/ut-liter.i Valor}
assign   iValor:label in frame f-resumido3 = trim(return-value).
{utp/ut-liter.i Equipamento }
assign   cEqpto:label in frame f-resumido3 = trim(return-value).
{utp/ut-liter.i Descri‡Æo }
assign   cDescEqpto:label in frame f-resumido3 = trim(return-value).

form mab-event.des-evento      
     cDescSubSist
     mab-movto-event.num-docto
     mab-movto-event.dat-inicial
     mab-movto-event.dat-final
     mab-movto-event.val-evento      
     with no-box width 132 64 down centered frame f-resumido2 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido2:HANDLE).

 
           
{utp/ut-liter.i Evento * R }
assign  mab-event.des-evento :label in frame f-resumido2 = trim(return-value).
{utp/ut-liter.i Subsistema}
assign cDescSubSist:label in frame f-resumido2 = trim(return-value).
{utp/ut-liter.i Execu‡Æo * R }
assign  mab-movto-event.dat-final:label in frame f-resumido2 = trim(return-value).

form iEmp      
     cEqpto
     cSubSist 
     cEvento   
     iDoc     
     dFinal    
     iValor     
     with no-box width 132 64 down centered frame f-resumido4 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido4:HANDLE).



{utp/ut-liter.i Evento * R }
assign  cEvento:label in frame f-resumido4 = trim(return-value).
{utp/ut-liter.i Subsistema}
assign cSubSist:label in frame f-resumido4 = trim(return-value).
{utp/ut-liter.i Execu‡Æo * R }
assign  dFinal  :label in frame f-resumido4 = trim(return-value).
{utp/ut-liter.i Emp}
assign  iEmp:label in frame f-resumido4 = trim(return-value).
{utp/ut-liter.i Valor}
assign   iValor:label in frame f-resumido4 = trim(return-value).
{utp/ut-liter.i Equipamento }
assign   cEqpto:label in frame f-resumido4 = trim(return-value).



form iEmp      
     cEqpto 
     cDescEqpto
     cEvento   
     iDoc  
     dInicial
     dFinal    
     iValor     
     with no-box width 132 64 down centered frame f-resumido5 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido5:HANDLE).



{utp/ut-liter.i Evento * R }
assign  cEvento:label in frame f-resumido5 = trim(return-value).
{utp/ut-liter.i Subsistema}
assign  dFinal  :label in frame f-resumido5 = trim(return-value).
{utp/ut-liter.i Emp}
assign  iEmp:label in frame f-resumido5 = trim(return-value).
{utp/ut-liter.i Valor}
assign   iValor:label in frame f-resumido5 = trim(return-value).
{utp/ut-liter.i Equipamento }
assign   cEqpto:label in frame f-resumido5 = trim(return-value).
{utp/ut-liter.i Abertura}
assign  dInicial:label in frame f-resumido5 = trim(return-value).
{utp/ut-liter.i Descri‡Æo }
assign   cDescEqpto:label in frame f-resumido5 = trim(return-value).

def temp-table tt-comp-folh
    field seq-de-imp as int
    field cd-comp   as char
    field cd-folha  as char.


/* Fim do Include */

       
    DEF temp-table tt-param                                            
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
         field l-EqptosMot          as logical                         
         field l-EqptosNMot         as logical                         
         field l-EqptosAtivos       as logical                         
         field l-EqptosInativos     as logical                         
         field l-EqptosProp         as logical                         
         field l-EqptosTerc         as logical                         
         field l-EventNEnc          as logical                         
         field l-EventEncerr        as logical                         
         field l-ManutOleo          as logical                         
         field l-ManutFiltros       as logical                         
         field l-ManutMec           as logical                         
         field l-MotivoParada       as logical                         
         field l-Custos             as logical                         
         field l-Outros             as logical 
         field l-insere             as logical                         
         field c-estabelec-ini      like mab-eqpto.cod-estabel           
         field c-estabelec-fim      like mab-eqpto.cod-estabel           
         field c-eqpto-ini          like mab-eqpto.cod-eqpto           
         field c-eqpto-fim          like mab-eqpto.cod-eqpto           
         field c-grupo-fim          like mab-eqpto.cod-grp-eqpto       
         field c-grupo-ini          like mab-eqpto.cod-grp-eqpto       
         field c-modelo-fim         like mab-eqpto.cod-model     
         field c-modelo-ini         like mab-eqpto.cod-model     
         field c-tag-fim            like mab-eqpto.cd-tag             
         field c-tag-ini            like mab-eqpto.cd-tag             
         field c-empresa-ini        like mab-eqpto.ep-codigo         
         field c-empresa-fim        like mab-eqpto.ep-codigo         
         field c-estrut-mec-ini     like mab-eqpto.cod-estrut-mec 
         field c-estrut-mec-fim     like mab-eqpto.cod-estrut-mec 
         field c-evento-ini         like mab-movto-event.cod-evento    
         field c-evento-fim         like mab-movto-event.cod-evento    
         field c-sub-sist-fim       like mab-movto-event.cod-sub-sist  
         field c-sub-sist-ini       like mab-movto-event.cod-sub-sist  
         field c-manut-ini          like mab-movto-event.cd-tipo 
         field c-manut-fim          like mab-movto-event.cd-tipo 
         field d-dat-inicial-ini    like mab-movto-event.dat-inicial   
         field d-dat-inicial-fim    like mab-movto-event.dat-inicial   
         field d-dat-final-ini      like mab-movto-event.dat-final     
         field d-dat-final-fim      like mab-movto-event.dat-final
         FIELD c-empresa-matr-ini   LIKE mab-movto-event.ep-codigo-matr
         FIELD c-empresa-matr-fim   LIKE mab-movto-event.ep-codigo-matr
         FIELD c-estabel-matr-ini   LIKE mab-movto-event.cod-estabel-matr
         FIELD c-estabel-matr-fim   LIKE mab-movto-event.cod-estabel-matr
         field c-cod-matr-ini       like mab-movto-event.cod-matr    
         field c-cod-matr-fim       like mab-movto-event.cod-matr
         FIELD c-custo-ini          LIKE mab-eqpto.cc-codigo
         FIELD c-custo-fim          LIKE mab-eqpto.cc-codigo
      &IF DEFINED(bf_mnt_ems206b) &THEN
         FIELD c-cod-unid-negoc-ini AS CHARACTER FORMAT "x(3)"
         FIELD c-cod-unid-negoc-fim AS CHARACTER FORMAT "x(3)"
      &ENDIF
        .
