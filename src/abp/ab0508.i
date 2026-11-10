{include/i_dbvers.i}
/* Definição da tt-param */
 
{cdp/cdcfgmnt.i}

 
DEFINE BUFFER bfeqpto FOR mab-eqpto.
DEFINE BUFFER bfmodel FOR mab-model.
DEFINE BUFFER bfmab-trajeto FOR mab-trajeto.
/****************** Defini‡ao de Vari veis de Sele‡Æo do Relat¢rio *********************/ 

def  var l-ViagemAnd   as logical    format "Sim/NÆo" label  "Viagens em Andamento"                         view-as toggle-box.
def  var l-ViagemConcl as logical    format "Sim/NÆo" label  "Viagens Conclu¡das"                           view-as toggle-box.
def  var l-ViagemKmAc  as logical    format "Sim/NÆo" label  "Viagens com KM Acima do estimado na Reserva"  view-as toggle-box.
def  var l-Insere      as logical    format "Sim/NÆo" label  "Insere Quebra de P gina"                       view-as toggle-box.
def  var i-viagem-ini        like mab-viagem.num-viagem    no-undo.                   
def  var i-viagem-fim        like mab-viagem.num-viagem    no-undo.      
def  var d-dt-saida-ini      like mab-viagem.dat-saida     no-undo.     
def  var d-dt-saida-fim      like mab-viagem.dat-saida     no-undo.      
def  var c-hr-saida-ini      like mab-viagem.hra-saida     no-undo.
def  var c-hr-saida-fim      like mab-viagem.hra-saida     no-undo.
def  var d-dt-ret-ini        like mab-viagem.dat-ret       no-undo.
def  var d-dt-ret-fim        like mab-viagem.dat-ret       no-undo.
def  var c-hr-ret-ini        like mab-viagem.hra-ret       no-undo.
def  var c-hr-ret-fim        like mab-viagem.hra-ret       no-undo.
def  var i-reserva-ini       like mab-viagem.num-reserva   no-undo.
def  var i-reserva-fim       like mab-viagem.num-reserva   no-undo.
def  var c-rota-ini          like mab-viagem.cod-rota      no-undo.
def  var c-rota-fim          like mab-viagem.cod-rota      no-undo.
def  var i-cod-emp-ini       like mab-viagem.ep-codigo     no-undo.
def  var i-cod-emp-fim       like mab-viagem.ep-codigo     no-undo.
def  var c-cod-eqpto-ini     like mab-viagem.cod-eqpto     no-undo.
def  var c-cod-eqpto-fim     like mab-viagem.cod-eqpto     no-undo.
def  var c-empresa-matr-ini  like mab-viagem.ep-codigo-matr   no-undo.
def  var c-empresa-matr-fim  like mab-viagem.ep-codigo-matr   no-undo.
def  var c-estabel-matr-ini  like mab-viagem.cod-estabel-matr no-undo.
def  var c-estabel-matr-fim  like mab-viagem.cod-estabel-matr no-undo.
def  var c-cod-matr-ini      like mab-viagem.cod-matr      no-undo.
def  var c-cod-matr-fim      like mab-viagem.cod-matr      no-undo.
def  var c-cod-grp-eqpto-ini like mab-eqpto.cod-grp-eqpto  no-undo.
def  var c-cod-grp-eqpto-fim like mab-eqpto.cod-grp-eqpto  no-undo.
                         


DEFINE VARIABLE c-eqpto       AS CHARACTER  LABEL "Equipamento"     NO-UNDO.
DEFINE VARIABLE c-data        AS CHARACTER  LABEL "Data S ida"            NO-UNDO.
DEFINE VARIABLE c-data-ret    AS CHARACTER  LABEL "Data Retorno"            NO-UNDO.
DEFINE VARIABLE c-emp         AS CHARACTER  LABEL "Empresa"      NO-UNDO.
DEFINE VARIABLE c-implto      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE LocOrig       AS CHARACTER  FORMAT "x(20)" NO-UNDO.
DEFINE VARIABLE LocDest       AS CHARACTER  FORMAT "x(20)" NO-UNDO.
DEFINE VARIABLE iEmp          AS CHAR  FORMAT "x(03)"  NO-UNDO.
DEFINE VARIABLE cEqpto        AS CHARACTER FORMAT "x(16)"  NO-UNDO.
DEFINE VARIABLE cHoraIni      AS CHARACTER FORMAT "x(08)" NO-UNDO.
DEFINE VARIABLE cHoraFim      AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE iNrViagem     AS CHAR FORMAT "x(09)"   NO-UNDO.
DEFINE VARIABLE dInicial      AS CHAR FORMAT "x(10)"   NO-UNDO.
DEFINE VARIABLE dFinal        AS CHAR FORMAT "x(10)"   NO-UNDO.
DEFINE VARIABLE cLocOrig      AS CHAR FORMAT "X(13)"  NO-UNDO.
DEFINE VARIABLE cLocDest      AS CHARACTER  FORMAT "X(12)"  NO-UNDO.
DEFINE VARIABLE cMotorista    AS CHARACTER FORMAT "X(21)" NO-UNDO.
DEFINE VARIABLE iKmEsp        AS CHAR  FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE cNomeMot      AS CHAR  FORMAT "X(21)"  NO-UNDO.
DEFINE VARIABLE Emp           AS CHAR  FORMAT "x(03)"  NO-UNDO.
DEFINE VARIABLE cHoraInicial  AS CHARACTER FORMAT "x(04)" NO-UNDO.
DEFINE VARIABLE iDocto        AS CHAR FORMAT "x(10)"   NO-UNDO.
DEFINE VARIABLE Hod-HorIni    AS CHAR FORMAT "x(16)"   NO-UNDO.
DEFINE VARIABLE Hod-HorFim    AS CHAR FORMAT "x(16)"   NO-UNDO.
DEFINE VARIABLE KmEst         AS DEC FORMAT  ">,>>>,>>9.9"   NO-UNDO.
DEFINE VARIABLE cContador     AS CHARACTER FORMAT "x(22)" NO-UNDO.
DEFINE VARIABLE cObservacao   AS CHARACTER FORMAT "x(11)" NO-UNDO.
DEFINE VARIABLE cGrupoEqpto   AS CHARACTER LABEL "Grupo Equipamento" FORMAT "x(17)" NO-UNDO.
DEFINE VARIABLE cDesGrpEqpto  LIKE mab-grp-eqpto.des-grp-eqpto  NO-UNDO.

DEFINE VARIABLE cContador-1     AS CHARACTER FORMAT "x(22)" NO-UNDO.
DEFINE VARIABLE iKmEsp-1 AS CHAR  FORMAT "x(08)"  NO-UNDO.

def    var c-traco              as character format "x(76)"           no-undo.
def    var l-primeira           as logical                            no-undo.
/****************************************************************************************************/

DEFINE TEMP-TABLE ttRelatViagem NO-UNDO
    FIELD ep-codigo                  LIKE mab-viagem.ep-codigo
    FIELD cod-eqpto                  LIKE mab-viagem.cod-eqpto
    FIELD ep-codigo-matr             LIKE mab-viagem.ep-codigo-matr
    FIELD cod-estabel-matr           LIKE mab-viagem.cod-estabel-matr
    FIELD cod-matr                   LIKE mab-viagem.cod-matr
    FIELD cod-rota                   LIKE mab-viagem.cod-rota
    FIELD hra-saida                  LIKE mab-viagem.hra-saida
    FIELD dat-ret                    LIKE mab-viagem.dat-ret
    FIELD hra-ret                    LIKE mab-viagem.hra-ret
    FIELD dat-saida                  LIKE mab-viagem.dat-saida
    FIELD num-reserva                LIKE mab-viagem.num-reserva
    FIELD num-viagem                 LIKE mab-viagem.num-viagem
    FIELD val-hodom-horim-inicial    LIKE mab-viagem.val-hodom-horim-inicial
    FIELD val-hodom-horim-final      LIKE mab-viagem.val-hodom-horim-final  
    FIELD dsl-obs                    LIKE mab-viagem.dsl-obs  
    FIELD cod-grp-eqpto              LIKE mab-eqpto.cod-grp-eqpto
    FIELD nom-motoris                LIKE mab-motoris.nom-motoris
    FIELD contador                   AS CHARACTER FORMAT "x(22)"
    FIELD nom-empresa                LIKE empresa.nome
    FIELD des-model                  LIKE mab-model.des-model.


/****************** Defini‡ao de Vari veis p/ Campos Virtuais do Relat¢rio *******************/ 

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

def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format "x(80)"
    index editor-id is primary unique linha.

form c-emp               
     ttRelatViagem.ep-codigo AT 23 NO-LABEL
     ttRelatViagem.nom-empresa AT 40 NO-LABEL  SKIP  
     c-eqpto             
     ttRelatViagem.cod-eqpto  NO-LABEL
     ttRelatViagem.des-model NO-LABEL SKIP (1)
     with  no-box  width 132 side-labels frame f-eqpto stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-eqpto:HANDLE).


FORM cGrupoEqpto      
     ttRelatViagem.cod-grp-eqpto NO-LABEL
     cDesGrpEqpto                NO-LABEL SKIP (2)
     with  no-box  width 132 side-labels frame f-grp-eqpto stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-grp-eqpto:HANDLE).


FORM c-data
     ttRelatViagem.dat-saida NO-LABEL SKIP (1)
    with no-box  width 132 side-labels frame f-data-saida stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-data-saida:HANDLE).



FORM c-data-ret
     ttRelatViagem.dat-ret NO-LABEL SKIP (1)
    with no-box  width 132 side-labels frame f-data-ret stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-data-ret:HANDLE).


form iNrViagem
     dInicial     AT 11
     cHoraIni     AT 22
     dFinal       AT 31
     cHoraFim     AT 42
     cLocOrig     AT 54
     cContador-1  AT 68
     Emp          AT 91
     cEqpto       AT 95
     cMotorista
     with no-box width 132 frame f-cabecalho1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cabecalho1:HANDLE).


form ttRelatViagem.num-viagem                   
     ttRelatViagem.dat-saida AT 11                   
     ttRelatViagem.hra-saida AT 22                   
     ttRelatViagem.dat-ret   AT 31              
     ttRelatViagem.hra-ret   AT 42                   
     ttRelatViagem.cod-rota  AT 54              
     ttRelatViagem.contador  AT 68              
     ttRelatViagem.ep-codigo AT 91              
     ttRelatViagem.cod-eqpto AT 95              
     ttRelatViagem.nom-motoris  FORMAT "x(21)"  
     with  no-box NO-LABELS width 132 frame f-resumido1 stream-io.


form ttRelatViagem.num-viagem                   NO-LABEL
     ttRelatViagem.dat-saida AT 11              NO-LABEL
     ttRelatViagem.hra-saida AT 22              NO-LABEL
     ttRelatViagem.dat-ret   AT 31              NO-LABEL
     ttRelatViagem.hra-ret   AT 42              NO-LABEL
     ttRelatViagem.cod-rota  AT 54              NO-LABEL
     ttRelatViagem.contador  AT 68              NO-LABEL
     ttRelatViagem.ep-codigo AT 91              NO-LABEL
     ttRelatViagem.cod-eqpto AT 95              NO-LABEL
     ttRelatViagem.nom-motoris  FORMAT "x(21)"  NO-LABEL SKIP  
    with  no-box  width 132 frame f-resumido1-1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido1-1:HANDLE).


{utp/ut-liter.i Documento * R }
assign  iNrViagem:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Dt_Sa¡da * R }
assign  dInicial:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Hr_Sa¡da * R }
assign  cHoraIni:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Dt_Retorno * R }
assign  dFinal:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Hr_Retorno * R }
assign  cHoraFim:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Reserva_local * R }
assign    cLocOrig:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Contador_Inicial/Final  * R }
assign    cContador-1:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Emp * R }
assign    Emp:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Equipamento * R }
assign    cEqpto:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Motorista * R }
assign    cMotorista:label in frame f-cabecalho1 = trim(return-value).

form cHoraIni   
     dFinal     
     cHoraFim
     iNrViagem 
     cLocOrig   
     cContador-1
     Emp        
     cEqpto     
     cMotorista 
     with no-box  width 132 frame f-cabecalho2 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cabecalho2:HANDLE).


form ttRelatViagem.hra-saida             NO-LABEL      
     ttRelatViagem.dat-ret    AT 10      NO-LABEL      
     ttRelatViagem.hra-ret               NO-LABEL      
     ttRelatViagem.num-viagem AT 32      NO-LABEL      
     ttRelatViagem.cod-rota   AT 42      NO-LABEL      
     ttRelatViagem.contador   AT 56      NO-LABEL      
     ttRelatViagem.ep-codigo  AT 79      NO-LABEL      
     ttRelatViagem.cod-eqpto  AT 83      NO-LABEL     
     ttRelatViagem.nom-motoris           NO-LABEL     
     with  no-box  width 132 side-labels frame f-resumido2 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido2:HANDLE).

 
form ttRelatViagem.hra-saida              NO-LABEL 
     ttRelatViagem.dat-ret    AT 10       NO-LABEL 
     ttRelatViagem.hra-ret                NO-LABEL 
     ttRelatViagem.num-viagem AT 32       NO-LABEL 
     ttRelatViagem.cod-rota   AT 42       NO-LABEL 
     ttRelatViagem.contador   AT 56       NO-LABEL 
     ttRelatViagem.ep-codigo  AT 79       NO-LABEL 
     ttRelatViagem.cod-eqpto  AT 83       NO-LABEL 
     ttRelatViagem.nom-motoris            NO-LABEL SKIP
     with  no-box  width 132 side-labels frame f-resumido2-1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido2-1:HANDLE).

          
{utp/ut-liter.i Documento * R }
ASSIGN  iNrViagem:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Hr_Sa¡da * R }
assign  cHoraIni:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Dt_Retorno * R }
assign  dFinal:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Hr_Retorno * R }
assign  cHoraFim:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Reserva_local * R }
assign  cLocOrig:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Contador_Inicial/Final  * R }
assign  cContador-1:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Emp * R }
assign  Emp:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Equipamento * R }
assign  cEqpto:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Motorista * R }
assign  cMotorista:label in frame f-cabecalho2 = trim(return-value).

 form cHoraFim
      dInicial
      cHoraIni
      iNrViagem
      cLocOrig
      cContador-1
      Emp
      cEqpto
      cMotorista
    with no-box  width 132 frame f-cabecalho3 stream-io.
 /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
 RUN utp/ut-trfrrp.p (INPUT FRAME f-cabecalho3:HANDLE).
 

 form ttRelatViagem.hra-ret                 NO-LABEL 
      ttRelatViagem.dat-saida   AT 12       NO-LABEL 
      ttRelatViagem.hra-saida               NO-LABEL 
      ttRelatViagem.num-viagem  AT 32       NO-LABEL 
      ttRelatViagem.cod-rota    AT 42       NO-LABEL 
      ttRelatViagem.contador    AT 56       NO-LABEL 
      ttRelatViagem.ep-codigo   AT 79       NO-LABEL 
      ttRelatViagem.cod-eqpto   AT 83       NO-LABEL 
      ttRelatViagem.nom-motoris AT 100      NO-LABEL 
    with  no-box  width 132 frame f-resumido3 stream-io.
 /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
 RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido3:HANDLE).
 

 form ttRelatViagem.hra-ret            NO-LABEL 
      ttRelatViagem.dat-saida   AT 12  NO-LABEL 
      ttRelatViagem.hra-saida          NO-LABEL 
      ttRelatViagem.num-viagem  AT 32  NO-LABEL 
      ttRelatViagem.cod-rota    AT 42  NO-LABEL 
      ttRelatViagem.contador    AT 56  NO-LABEL 
      ttRelatViagem.ep-codigo   AT 79  NO-LABEL 
      ttRelatViagem.cod-eqpto   AT 83  NO-LABEL 
      ttRelatViagem.nom-motoris AT 100 NO-LABEL SKIP 
    with  no-box  width 132  frame f-resumido3-1 stream-io.
 /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
 RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido3-1:HANDLE).
 

{utp/ut-liter.i Documento * R }
assign  iNrViagem:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Dt_Sa¡da * R }
assign  dInicial:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Hr_Sa¡da * R }
assign  cHoraIni:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Hr_Retorno * R }
assign  cHoraFim:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Reserva_local * R }
assign  cLocOrig:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Contador_Inicial/Final  * R }
assign  cContador-1:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Emp * R }
assign  Emp:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Equipamento * R }
assign  cEqpto:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Motorista * R }
assign  cMotorista:label in frame f-cabecalho3 = trim(return-value).

form iNrViagem
     dInicial
     cHoraIni
     dFinal  
     cHoraFim
     cLocOrig
     cContador-1
     cMotorista
     "--------- ---------- -------- ---------- ---------- ------------- ---------------------- -------------------------------------------"
     with no-box NO-LABELS width 132 frame f-cabecalho4 STREAM-IO.

form ttRelatViagem.num-viagem                          
     ttRelatViagem.dat-saida   AT 11                   
     ttRelatViagem.hra-saida   AT 22                   
     ttRelatViagem.dat-ret     AT 31                   
     ttRelatViagem.hra-ret     AT 42                   
     ttRelatViagem.cod-rota    AT 53                   
     ttRelatViagem.contador    AT 67                
     ttRelatViagem.nom-motoris AT 90               
     with  no-box NO-LABEL width 132 frame f-resumido4 stream-io.
 
form ttRelatViagem.num-viagem                    NO-LABEL     
     ttRelatViagem.dat-saida   AT 11             NO-LABEL     
     ttRelatViagem.hra-saida   AT 22             NO-LABEL     
     ttRelatViagem.dat-ret     AT 31             NO-LABEL     
     ttRelatViagem.hra-ret     AT 42             NO-LABEL     
     ttRelatViagem.cod-rota    AT 53             NO-LABEL     
     ttRelatViagem.contador    AT 67             NO-LABEL  
     ttRelatViagem.nom-motoris AT 90             NO-LABEL SKIP
     with  no-box  width 132 frame f-resumido4-1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido4-1:HANDLE).


{utp/ut-liter.i Documento * R }
assign  iNrViagem = trim(return-value).
{utp/ut-liter.i Dt_Sa¡da * R }
assign  dInicial = trim(return-value).
{utp/ut-liter.i Hr_Sa¡da * R }
assign  cHoraIni = trim(return-value).
{utp/ut-liter.i Dt_Retorno * R }
assign  dFinal = trim(return-value).
{utp/ut-liter.i Hr_Retorno * R }
assign  cHoraFim = trim(return-value).
{utp/ut-liter.i Reserva_local * R }
assign  cLocOrig = trim(return-value).
{utp/ut-liter.i Contador_Inicial/Final  * R }
assign  cContador-1 = trim(return-value).
{utp/ut-liter.i Motorista * R }
assign  cMotorista = trim(return-value).


form Emp   
     cEqpto        AT 05 
     iNrViagem     AT 22 
     dInicial      AT 32 
     cHoraIni      AT 43 
     dFinal        AT 52 
     cHoraFim      AT 63 
     cLocOrig      AT 74 
     cContador-1   AT 88 
     cMotorista    AT 111
     with NO-BOX  WIDTH 132 frame f-cabecalho5 STREAM-IO.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cabecalho5:HANDLE).


form ttRelatViagem.ep-codigo                      
     ttRelatViagem.cod-eqpto   AT 05              
     ttRelatViagem.num-viagem  AT 22                  
     ttRelatViagem.dat-saida   AT 32                  
     ttRelatViagem.hra-saida   AT 43                  
     ttRelatViagem.dat-ret     AT 52                  
     ttRelatViagem.hra-ret     AT 63                  
     ttRelatViagem.cod-rota    AT 74                  
     ttRelatViagem.contador    AT 88               
     ttRelatViagem.nom-motoris   FORMAT "X(20)"   
     with  no-box NO-LABEL width 132 frame f-resumido5 stream-io.
 
form ttRelatViagem.ep-codigo                     NO-LABEL
     ttRelatViagem.cod-eqpto   AT 05             NO-LABEL
     ttRelatViagem.num-viagem  AT 22             NO-LABEL
     ttRelatViagem.dat-saida   AT 32             NO-LABEL
     ttRelatViagem.hra-saida   AT 43             NO-LABEL
     ttRelatViagem.dat-ret     AT 52             NO-LABEL
     ttRelatViagem.hra-ret     AT 63             NO-LABEL
     ttRelatViagem.cod-rota    AT 74             NO-LABEL
     ttRelatViagem.contador    AT 88             NO-LABEL
     ttRelatViagem.nom-motoris  FORMAT "X(20)"   NO-LABEL         SKIP
     with  no-box  width 132 frame f-resumido5-1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido5-1:HANDLE).



{utp/ut-liter.i Emp * R }
assign  Emp:label in frame f-cabecalho5 = trim(return-value).
{utp/ut-liter.i Equipamento * R }
assign  cEqpto:label in frame f-cabecalho5 = trim(return-value).
{utp/ut-liter.i Documento * R }
assign  iNrViagem:label in frame f-cabecalho5 = trim(return-value).
{utp/ut-liter.i Dt_Sa¡da * R }
assign  dInicial:label in frame f-cabecalho5 = trim(return-value).
{utp/ut-liter.i Hr_Sa¡da * R }
assign  cHoraIni:label in frame f-cabecalho5 = trim(return-value).
{utp/ut-liter.i Dt_Retorno * R }
assign  dFinal:label in frame f-cabecalho5 = trim(return-value).
{utp/ut-liter.i Hr_Retorno * R }
assign  cHoraFim:label in frame f-cabecalho5 = trim(return-value).
{utp/ut-liter.i Reserva_local * R }
assign  cLocOrig:label in frame f-cabecalho5 = trim(return-value).
{utp/ut-liter.i Contador_Inicial/Final  * R }
assign  cContador-1:label in frame f-cabecalho5 = trim(return-value).
{utp/ut-liter.i Motorista * R }
assign  cMotorista:label in frame f-cabecalho5 = trim(return-value).


FORM mab-viagem-implto.ep-codigo AT 12 NO-LABEL
     mab-viagem-implto.cod-eqpto NO-LABEL
     bfmodel.des-model           NO-LABEL SKIP
     with no-box  width 132 side-labels frame f-implemento stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-implemento:HANDLE).


FORM c-implto AT 12
    with no-box  width 132 side-labels frame f-cab-implemento stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cab-implemento:HANDLE).


{utp/ut-liter.i Implemento * R }
assign  c-implto:label in frame f-cab-implemento = trim(return-value).

FORM  tt-editor.conteudo   
     with NO-LABEL stream-io  width 132  frame f-imp.

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
         field l-ViagemAnd          as logical  
         field l-ViagemConcl        as logical
         field l-ViagemKmAc         as logical
         field l-Insere             as logical 
         FIELD l-ImprimeObs         AS LOGICAL
         field i-viagem-ini         like mab-viagem.num-viagem
         field i-viagem-fim         like mab-viagem.num-viagem
         field d-dt-saida-ini       like mab-viagem.dat-saida
         field d-dt-saida-fim       like mab-viagem.dat-saida
         field c-hr-saida-ini       like mab-viagem.hra-saida
         field c-hr-saida-fim       like mab-viagem.hra-saida
         field d-dt-ret-ini         like mab-viagem.dat-ret
         field d-dt-ret-fim         like mab-viagem.dat-ret
         field c-hr-ret-ini         like mab-viagem.hra-ret
         field c-hr-ret-fim         like mab-viagem.hra-ret
         field i-reserva-ini        like mab-viagem.num-reserva
         field i-reserva-fim        like mab-viagem.num-reserva
         field c-rota-ini           like mab-viagem.cod-rota
         field c-rota-fim           like mab-viagem.cod-rota
         field i-cod-emp-ini        like mab-viagem.ep-codigo
         field i-cod-emp-fim        like mab-viagem.ep-codigo
         field c-cod-eqpto-ini      like mab-viagem.cod-eqpto
         field c-cod-eqpto-fim      like mab-viagem.cod-eqpto
         FIELD c-empresa-matr-ini   LIKE mab-viagem.ep-codigo-matr
         FIELD c-empresa-matr-fim   LIKE mab-viagem.ep-codigo-matr
         FIELD c-estabel-matr-ini   LIKE mab-viagem.cod-estabel-matr
         FIELD c-estabel-matr-fim   LIKE mab-viagem.cod-estabel-matr
         field c-cod-matr-ini       like mab-viagem.cod-matr
         field c-cod-matr-fim       like mab-viagem.cod-matr
         FIELD c-cod-grp-eqpto-ini  LIKE mab-eqpto.cod-grp-eqpto
         FIELD c-cod-grp-eqpto-fim  LIKE mab-eqpto.cod-grp-eqpto.
        






