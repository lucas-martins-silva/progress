{include/i_dbvers.i}
/* Definição da tt-param */
 
{cdp/cdcfgmnt.i}

 
DEFINE BUFFER bfeqpto FOR mab-eqpto.
DEFINE BUFFER bfmodel FOR mab-model.
DEFINE BUFFER bfmab-trajeto FOR mab-trajeto.
/****************** Defini‡ao de Vari veis de Sele‡Æo do Relat¢rio *********************/ 

def  var l-ReservaAtend       as logical    format "Sim/NÆo" label  "Reservas Atendidas      " view-as toggle-box.
def  var l-ReservaNAtend      as logical    format "Sim/NÆo" label  "Reservas NÆo Atendidas  " view-as toggle-box.
def  var l-Insere             as logical    format "Sim/NÆo" label  "Insere Quebra de P gina " view-as toggle-box.
def  var i-reserva-ini        like mab-reserva.num-reserva          no-undo.                   
def  var i-reserva-fim        like mab-reserva.num-reserva          no-undo.      
def  var d-data-ini           like mab-reserva.dat-reserva-inicial  no-undo.     
def  var d-data-fim           like mab-reserva.dat-reserva-final    no-undo.      
def  var c-hora-ini           like mab-reserva.hra-reserva-inicial  no-undo.
def  var c-hora-fim           like mab-reserva.hra-reserva-final    no-undo.
def  var c-rota-orig-ini      like mab-reserva.cod-rota-orig        no-undo.
def  var c-rota-orig-fim      like mab-reserva.cod-rota-orig        no-undo.
def  var c-rota-dest-ini      like mab-reserva.cod-rota-dest        no-undo.
def  var c-rota-dest-fim      like mab-reserva.cod-rota-dest        no-undo.
def  var i-cod-emp-ini        like mab-reserva.ep-codigo            no-undo.
def  var i-cod-emp-fim        like mab-reserva.ep-codigo            no-undo.
def  var c-cod-eqpto-ini      like mab-reserva.cod-eqpto            no-undo.
def  var c-cod-eqpto-fim      like mab-reserva.cod-eqpto            no-undo.

def  var c-empresa-matr-ini   like mab-reserva.ep-codigo-matr       no-undo.
def  var c-empresa-matr-fim   like mab-reserva.ep-codigo-matr       no-undo.
def  var c-estabel-matr-ini   like mab-reserva.cod-estabel-matr     no-undo.
def  var c-estabel-matr-fim   like mab-reserva.cod-estabel-matr     no-undo.
def  var c-cod-matr-ini       like mab-reserva.cod-matr             no-undo.
def  var c-cod-matr-fim       like mab-reserva.cod-matr             no-undo.

DEFINE VARIABLE cEquipamento  AS CHARACTER FORMAT "x(12)"           NO-UNDO.
DEFINE VARIABLE c-data        AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE cEmpresa      AS CHARACTER FORMAT "x(08)"           NO-UNDO.
DEFINE VARIABLE c-implto      AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE LocOrig       AS CHARACTER  FORMAT "x(19)" NO-UNDO.
DEFINE VARIABLE LocDest       AS CHARACTER  FORMAT "x(19)" NO-UNDO.
DEFINE VARIABLE iEmp          AS CHAR  FORMAT "x(03)"  NO-UNDO.
DEFINE VARIABLE cEqpto        AS CHARACTER FORMAT "x(16)"  NO-UNDO.
DEFINE VARIABLE cHoraIni      AS CHARACTER FORMAT "x(08)" NO-UNDO.
DEFINE VARIABLE cHoraFim      AS CHARACTER FORMAT "x(08)" NO-UNDO.
DEFINE VARIABLE NrReserva     AS CHAR FORMAT "x(10)"   NO-UNDO.
DEFINE VARIABLE dInicial      AS CHAR FORMAT "x(10)"   NO-UNDO.
DEFINE VARIABLE dFinal        AS CHAR FORMAT "x(10)"   NO-UNDO.
DEFINE VARIABLE cLocOrig      AS CHAR FORMAT "X(18)"  NO-UNDO.
DEFINE VARIABLE cLocDest      AS CHARACTER  FORMAT "X(18)"  NO-UNDO.
DEFINE VARIABLE cMotorista    AS CHARACTER FORMAT "X(22)" NO-UNDO.

DEFINE VARIABLE cObservacao   AS CHARACTER FORMAT "X(11)" NO-UNDO.
DEFINE VARIABLE cLocOrig-4    AS CHAR FORMAT "X(12)"  NO-UNDO.
DEFINE VARIABLE cLocDest-4    AS CHARACTER  FORMAT "X(12)"  NO-UNDO.
DEFINE VARIABLE cMotorista-4  AS CHARACTER FORMAT "X(30)" NO-UNDO.
DEFINE VARIABLE iKmEsp        AS CHAR  FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE cNomeMot      AS CHAR  FORMAT "X(30)"  NO-UNDO.
DEFINE VARIABLE Emp           AS CHAR  FORMAT "x(03)"  NO-UNDO.
DEFINE VARIABLE cHrIni  AS CHARACTER FORMAT "x(08)" NO-UNDO.
DEFINE VARIABLE iDocto        AS CHAR FORMAT "x(09)"   NO-UNDO.

DEFINE VARIABLE iKmEsp-1 AS CHAR  FORMAT "x(08)"  NO-UNDO.

def    var c-obs                as character format "x(11)"           no-undo.
def    var c-traco              as character format "x(76)"           no-undo.
def    var l-primeira           as logical                            no-undo.
/****************************************************************************************************/


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


def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format "x(80)"
    index editor-id is primary unique linha.

def temp-table tt-raw-digita
    field raw-digita as raw.

form cEmpresa    AT 01           
     mab-reserva.ep-codigo NO-LABEL
     empresa.nome  NO-LABEL SKIP   
     cEquipamento   AT 01          
     mab-reserva.cod-eqpto  NO-LABEL
     mab-model.des-model  NO-LABEL 
     with  no-box  width 132 side-labels frame f-eqpto stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-eqpto:HANDLE).



{utp/ut-liter.i Empresa }
assign  cEmpresa:label in frame f-eqpto = trim(return-value).
{utp/ut-liter.i Equipamento }
assign  cEquipamento:label in frame f-eqpto = trim(return-value).



FORM c-data
     mab-reserva.dat-reserva-inicial NO-LABEL 
    with  no-box  width 132 side-labels frame f-data stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-data:HANDLE).

{utp/ut-liter.i Data * R }
assign  c-data:label in frame f-data = trim(return-value).



form NrReserva
     dInicial
     cHoraIni
     dFinal
     cHoraFim
     cLocOrig-4 AT 52
     cLocDest-4 AT 65
     Emp
     cEqpto
     cMotorista 
     iKmEsp  AT 122
     with no-box PAGE-TOP width 132 frame f-cabecalho1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cabecalho1:HANDLE).




form  mab-reserva.num-reserva             AT 01    NO-LABEL
      mab-reserva.dat-reserva-inicial     AT 12    NO-LABEL
      mab-reserva.hra-reserva-inicial              NO-LABEL
      mab-reserva.dat-reserva-final       AT 32    NO-LABEL
      mab-reserva.hra-reserva-final                NO-LABEL
      mab-reserva.cod-rota-orig           AT 52    NO-LABEL
      mab-reserva.cod-rota-dest           AT 65    NO-LABEL
      mab-reserva.cod-rota-dest                    NO-LABEL
      mab-reserva.ep-codigo                        NO-LABEL
      mab-reserva.cod-eqpto                        NO-LABEL
      mab-motoris.nom-motoris                      NO-LABEL  FORMAT "x(22)"
      mab-reserva.val-km-estimad                   NO-LABEL  FORMAT "Z,ZZZ,ZZ9.9" SKIP
     with  no-box  width 132 side-labels frame f-resumido2 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido2:HANDLE).

           
form  mab-reserva.num-reserva         AT 01  NO-LABEL
      mab-reserva.dat-reserva-inicial AT 12  NO-LABEL
      mab-reserva.hra-reserva-inicial        NO-LABEL
      mab-reserva.dat-reserva-final   AT 32  NO-LABEL
      mab-reserva.hra-reserva-final          NO-LABEL
      mab-reserva.cod-rota-orig       AT 52  NO-LABEL
      mab-reserva.cod-rota-dest       AT 65  NO-LABEL
      mab-reserva.cod-rota-dest              NO-LABEL
      mab-reserva.ep-codigo                  NO-LABEL
      mab-reserva.cod-eqpto                  NO-LABEL
      mab-motoris.nom-motoris                NO-LABEL  FORMAT "x(22)"
      mab-reserva.val-km-estimad             NO-LABEL  FORMAT "Z,ZZZ,ZZ9.9" SKIP
     with  no-box  width 132 side-labels frame f-resumido2-1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido2-1:HANDLE).


{utp/ut-liter.i Documento * R }
assign  NrReserva:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Dt_Inicial * R }
assign  dInicial:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Hr_Inici * R }
assign  cHoraIni:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Dt_Final * R }
assign  dFinal:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Hr_Final * R }
assign  cHoraFim:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Loc_Origem * R }
assign    cLocOrig-4:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Loc_Destino * R }
assign    cLocDest-4:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Emp * R }
assign    Emp:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Equipamento * R }
assign    cEqpto:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Motorista * R }
assign    cMotorista:label in frame f-cabecalho1 = trim(return-value).
{utp/ut-liter.i Percurso MAB R }
assign    iKmEsp:label in frame f-cabecalho1 = trim(return-value).

form cHrIni       AT 01    FORMAT "x(08)" 
     dFinal       AT 10
     cHoraFim     AT 21
     iDocto       AT 30
     cLocOrig     AT 40
     cLocDest     AT 60
     Emp          AT 80      FORMAT "x(03)"
     cEqpto       AT 84   
     cMotorista   AT 101     FORMAT "X(20)"
     iKmEsp       AT 122     FORMAT "x(11)"
     with NO-BOX width 132 frame f-cabecalho2 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cabecalho2:HANDLE).


form  mab-reserva.hra-reserva-inicial AT 01   NO-LABEL
      mab-reserva.dat-reserva-final   AT 10   NO-LABEL
      mab-reserva.hra-reserva-final   AT 21   NO-LABEL
      mab-reserva.num-reserva         AT 30   NO-LABEL
      LocOrig                         AT 40   NO-LABEL
      LocDest                         AT 60   NO-LABEL
      mab-reserva.ep-codigo           AT 80   NO-LABEL
      mab-reserva.cod-eqpto           AT 84   NO-LABEL
      mab-motoris.nom-motoris         AT 101  NO-LABEL  FORMAT "X(20)"
      mab-reserva.val-km-estimad      AT 122  NO-LABEL  FORMAT "Z,ZZZ,ZZ9.9"
      with no-box width 132 64 down CENTERED  frame f-resumido3 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido3:HANDLE).


form  mab-reserva.hra-reserva-inicial AT 01    NO-LABEL
      mab-reserva.dat-reserva-final   AT 10    NO-LABEL
      mab-reserva.hra-reserva-final   AT 21    NO-LABEL
      mab-reserva.num-reserva         AT 30    NO-LABEL
      LocOrig                         AT 40    NO-LABEL
      LocDest                         AT 60    NO-LABEL
      mab-reserva.ep-codigo           AT 80    NO-LABEL
      mab-reserva.cod-eqpto           AT 84    NO-LABEL
      mab-motoris.nom-motoris         AT 101   NO-LABEL  FORMAT "X(20)"
      mab-reserva.val-km-estimad      AT 122   NO-LABEL  FORMAT "Z,ZZZ,ZZ9.9"
      with  no-box  width 132 frame f-resumido3-1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido3-1:HANDLE).



{utp/ut-liter.i Documento * R }
assign  iDocto:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Hr_Inici * R }
assign  cHrIni:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Dt_Final * R }
assign  dFinal:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Hr_Final * R }
assign  cHoraFim:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Loc_Origem * R }
assign    cLocOrig:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Loc_Destino * R }
assign    cLocDest:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Motorista * R }
assign    cMotorista:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Percurso MAB R }
assign    iKmEsp:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Emp * R }
assign    Emp:label in frame f-cabecalho2 = trim(return-value).
{utp/ut-liter.i Equipamento * R }
assign    cEqpto:label in frame f-cabecalho2 = trim(return-value).

form NrReserva      AT 01  FORMAT "x(10)"
     dInicial       AT 12                
     cHoraIni       AT 23  FORMAT "x(08)"
     dFinal         AT 32 
     cHoraFim       AT 43 
     cLocOrig       AT 52 
     cLocDest       AT 72 
     cMotorista-4   AT 92  FORMAT "x(29)"
     iKmEsp         AT 122
     with NO-BOX PAGE-TOP TOP-ONLY width 132 frame f-cabecalho3 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cabecalho3:HANDLE).


form  mab-reserva.num-reserva         AT 01   NO-LABEL
      mab-reserva.dat-reserva-inicial AT 12   NO-LABEL
      mab-reserva.hra-reserva-inicial AT 23   NO-LABEL
      mab-reserva.dat-reserva-final   AT 32   NO-LABEL
      mab-reserva.hra-reserva-final   AT 43   NO-LABEL
      LocOrig                         AT 52   NO-LABEL
      LocDest                         AT 72   NO-LABEL
      cNomeMot                        AT 92   NO-LABEL FORMAT "x(29)"
      mab-reserva.val-km-estimad      AT 122 FORMAT "Z,ZZZ,ZZ9.9"  NO-LABEL  
      with no-box width 132 64 down centered frame f-resumido4 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido4:HANDLE).


form  mab-reserva.num-reserva         AT 01   NO-LABEL
      mab-reserva.dat-reserva-inicial AT 12   NO-LABEL
      mab-reserva.hra-reserva-inicial AT 23   NO-LABEL
      mab-reserva.dat-reserva-final   AT 32   NO-LABEL
      mab-reserva.hra-reserva-final   AT 43   NO-LABEL
      LocOrig                         AT 52   NO-LABEL
      LocDest                         AT 72   NO-LABEL
      cNomeMot                        AT 92   NO-LABEL  FORMAT "x(29)"
      mab-reserva.val-km-estimad      AT 122  NO-LABEL  FORMAT "Z,ZZZ,ZZ9.9"
    with  no-box  width 132 frame f-resumido4-1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-resumido4-1:HANDLE).


 
{utp/ut-liter.i Documento * R }
assign  NrReserva:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Dt_Inicial * R }
assign  dInicial:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Hr_Inici * R }
assign  cHoraIni:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Dt_Final * R }
assign  dFinal:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Hr_Final * R }
assign  cHoraFim:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Loc_Origem * R }
assign    cLocOrig:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Loc_Destino * R }
assign    cLocDest:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Motorista * R }
assign    cMotorista-4:label in frame f-cabecalho3 = trim(return-value).
{utp/ut-liter.i Percurso MAB R }
assign    iKmEsp:label in frame f-cabecalho3 = trim(return-value).
           
FORM cObservacao AT 10
     with stream-io  width 132  frame  f-obs.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-obs:HANDLE).


FORM  tt-editor.conteudo   
     with NO-LABEL stream-io  width 132  frame f-imp.

FORM c-implto AT 10
     with no-box  width 132 side-labels frame f-implemento stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-implemento:HANDLE).


{utp/ut-liter.i Implemento MAB R }
assign  c-implto:label in frame f-implemento = trim(return-value).

FORM mab-reserva-implto.ep-codigo AT 10 NO-LABEL
     mab-reserva-implto.cod-eqpto       NO-LABEL
     bfmodel.des-model                  NO-LABEL 
     with NO-LABEL no-box  width 132 frame f-dados-implemento stream-io.



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
          field l-ReservaAtend       as logical  
          field l-ReservaNAtend      as logical  
          field l-Insere             as logical
          field i-reserva-ini        like mab-reserva.num-reserva
          field i-reserva-fim        like mab-reserva.num-reserva
          field d-data-ini           like mab-reserva.dat-reserva-inicial
          field d-data-fim           like mab-reserva.dat-reserva-final
          field c-hora-ini           like mab-reserva.hra-reserva-inicial
          field c-hora-fim           like mab-reserva.hra-reserva-final
          field c-rota-orig-ini      like mab-reserva.cod-rota-orig
          field c-rota-orig-fim      like mab-reserva.cod-rota-orig
          field c-rota-dest-ini      like mab-reserva.cod-rota-dest
          field c-rota-dest-fim      like mab-reserva.cod-rota-dest
          field i-cod-emp-ini        like mab-reserva.ep-codigo
          field i-cod-emp-fim        like mab-reserva.ep-codigo
          field c-cod-eqpto-ini      like mab-reserva.cod-eqpto
          field c-cod-eqpto-fim      like mab-reserva.cod-eqpto
          FIELD c-empresa-matr-ini   like mab-reserva.ep-codigo-matr  
          FIELD c-empresa-matr-fim   like mab-reserva.ep-codigo-matr  
          field c-estabel-matr-ini   like mab-reserva.cod-estabel-matr
          field c-estabel-matr-fim   like mab-reserva.cod-estabel-matr
          field c-cod-matr-ini       like mab-reserva.cod-matr
          field c-cod-matr-fim       like mab-reserva.cod-matr.

           






