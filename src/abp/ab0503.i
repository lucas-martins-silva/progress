{include/i_dbvers.i}
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
****************** Defini‡ao de Vari veis de Sele‡Æo do Relat¢rio *********************/ 
DEFINE VARIABLE l-afericoes      as   logical                       view-as toggle-box.
DEFINE VARIABLE l-transf         as   logical                       view-as toggle-box.
DEFINE VARIABLE l-leitura        as   logical                       view-as toggle-box.
DEFINE VARIABLE l-Insere         as   logical                       view-as toggle-box.
DEFINE VARIABLE d-data-ini       like mab-control-bomba.dat-apont   no-undo.                   
DEFINE VARIABLE d-data-fim       like mab-control-bomba.dat-apont   no-undo.      
DEFINE VARIABLE c-hora-ini       like mab-control-bomba.hra-apont   no-undo.     
DEFINE VARIABLE c-hora-fim       like mab-control-bomba.hra-apont   no-undo.      
DEFINE VARIABLE c-posto-ini      like mab-posto.cod-posto           no-undo.
DEFINE VARIABLE c-posto-fim      like mab-posto.cod-posto           no-undo.
DEFINE VARIABLE i-docto-ini      like mab-control-bomba.num-docto   no-undo.
DEFINE VARIABLE i-docoto-fim     like mab-control-bomba.num-docto   no-undo.
DEFINE VARIABLE c-traco          as   character format "x(76)"      no-undo.
DEFINE VARIABLE l-primeira       as   logical                       no-undo.
DEFINE VARIABLE cTpApont         as   character format "x(16)"      no-undo.
DEFINE VARIABLE cDocto           as   character FORMAT "x(09)"      no-undo.
DEFINE VARIABLE cData            as   character FORMAT "x(10)"      no-undo.
DEFINE VARIABLE cHora            as   character FORMAT "99:99"      no-undo.
DEFINE VARIABLE cPstOrig         as   character FORMAT "x(10)"      no-undo.
DEFINE VARIABLE cBomba           as   character FORMAT "x(08)"                    no-undo.
DEFINE VARIABLE cMaterial        as   character format "x(16)"      no-undo.
DEFINE VARIABLE cValIni-1        as   character format "x(13)"      no-undo.
DEFINE VARIABLE cValFim-1        as   character format "x(13)"      no-undo.
DEFINE VARIABLE cQtde-1          as   character FORMAT "x(13)"      no-undo.
DEFINE VARIABLE cPstDest         as   character FORMAT "x(07)"      no-undo.
DEFINE VARIABLE cApont           as   character format "x(19)"      no-undo.

/****************** Defini‡ao de Vari veis p/ Campos Virtuais do Relat¢rio *******************/ 
DEFINE VARIABLE c-traco-1            as char    no-undo.
DEFINE VARIABLE h-acomp              as handle  no-undo.
DEFINE VARIABLE v-cod-destino-impres as char    no-undo.
DEFINE VARIABLE v-num-reg-lidos      as int     no-undo.
DEFINE VARIABLE v-num-point          as int     no-undo.
DEFINE VARIABLE v-num-set            as int     no-undo.
DEFINE VARIABLE v-num-linha          as int     no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE VARIABLE i-ep-codigo-usuario  LIKE empresa.ep-codigo     no-undo.
&ELSE
DEFINE VARIABLE i-ep-codigo-usuario  as int     no-undo.
&ENDIF
DEFINE VARIABLE l-imprime            as LOGICAL no-undo.

def temp-table tt-raw-digita
    field raw-digita as raw.

form  HEADER  cDocto         AT 01 FORMAT "x(09)"  
              cTpApont       AT 10 FORMAT "x(16)"
              cData          AT 28 
              cHora          AT 39  
              cPstOrig       AT 45   
              cBomba         AT 56 
              cMaterial      AT 65   
              cValIni-1      AT 82   
              cValFim-1      AT 96  
              cQtde-1        AT 110
              cPstDest       AT 124 FORMAT "x(07)"
              with no-box  PAGE-TOP TOP-ONLY WIDTH 132 frame f-cabecalho-1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cabecalho-1:HANDLE).


form    mab-control-bomba.num-docto           NO-LABEL  AT 01  FORMAT ">>>>>>>9"  
        cApont                                NO-LABEL  AT 10  format "x(16)"
        mab-control-bomba.dat-apont           NO-LABEL  AT 28  
        mab-control-bomba.hra-apont           NO-LABEL  AT 39  FORMAT "99:99" 
        mab-control-bomba.cod-posto-orig      NO-LABEL  AT 45  
        mab-control-bomba.cod-bomba           NO-LABEL  AT 56  FORMAT "X(08)"  
        mab-tip-mater.des-tip-mater           NO-LABEL  AT 65  format "x(16)"  
        mab-control-bomba.val-leitura-inicial NO-LABEL  AT 82 
        mab-control-bomba.val-leitura-final   NO-LABEL  AT 96 
        mab-control-bomba.val-quant           NO-LABEL  AT 110
        mab-control-bomba.cod-posto-dest      NO-LABEL  AT 124 FORMAT "x(07)"
        with no-box  WIDTH 132 frame f-dados-1 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-dados-1:HANDLE).


{utp/ut-liter.i Tipo * R }
assign  cTpApont:label in frame f-cabecalho-1 = trim(return-value).
{utp/ut-liter.i Bomba * R }
assign  cBomba:label in frame f-cabecalho-1 = trim(return-value).
{utp/ut-liter.i Material * R }
assign  cMaterial:label in frame f-cabecalho-1 = trim(return-value).
{utp/ut-liter.i Docto * R }
assign  cDocto:label in frame f-cabecalho-1 = trim(return-value).
{utp/ut-liter.i Inicial * R }
assign   cValIni-1:label in frame f-cabecalho-1 = trim(return-value).
{utp/ut-liter.i Final * R }
assign    cValFim-1:label in frame f-cabecalho-1 = trim(return-value).
{utp/ut-liter.i Qtde * R }
assign    cQtde-1:label in frame f-cabecalho-1 = trim(return-value).
{utp/ut-liter.i Data * R }
assign    cData:label in frame f-cabecalho-1 = trim(return-value).
{utp/ut-liter.i Hora * R }
assign    cHora:label in frame f-cabecalho-1 = trim(return-value).
{utp/ut-liter.i Posto_Orig * R }
assign    cPstOrig:label in frame f-cabecalho-1 = trim(return-value).
{utp/ut-liter.i Pst_Des * R }
assign    cPstDest:label in frame f-cabecalho-1 = trim(return-value).

form    cData          AT 01                  
        cHora          AT 12                  
        cTpApont       AT 18                
        cDocto         AT 35                  
        cPstOrig       AT 45                  
        cBomba         AT 56                  
        cMaterial      AT 65                  
        cValIni-1      AT 82                  
        cValFim-1      AT 96              
        cQtde-1        AT 110
        cPstDest       AT 124   FORMAT "x(07)"
        with no-box  width 132 frame f-cabecalho-2 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cabecalho-2:HANDLE).


form   mab-control-bomba.dat-apont            NO-LABEL  AT 01                       
       mab-control-bomba.hra-apont            NO-LABEL  AT 12    FORMAT "99:99"     
       cApont                                 NO-LABEL  AT 18    format "x(16)"     
       mab-control-bomba.num-docto            NO-LABEL  AT 35    FORMAT ">>>>>>>>9" 
       mab-control-bomba.cod-posto-orig       NO-LABEL  AT 45                       
       mab-control-bomba.cod-bomba            NO-LABEL  AT 56    FORMAT "X(08)"     
       mab-tip-mater.des-tip-mater            NO-LABEL  AT 65    format "x(16)"     
       mab-control-bomba.val-leitura-inicial  NO-LABEL  AT 82    FORMAT ">>,>>>,>>9.99"                   
       mab-control-bomba.val-leitura-final    NO-LABEL  AT 96    FORMAT ">>,>>>,>>9.99"                  
       mab-control-bomba.val-quant            NO-LABEL  AT 110   FORMAT ">>,>>>,>>9.99"
       mab-control-bomba.cod-posto-dest       NO-LABEL  AT 124   FORMAT "x(07)"                   
        with no-box  width 132 frame f-dados-2 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-dados-2:HANDLE).


{utp/ut-liter.i Tipo * R }
assign  cTpApont:label in frame f-cabecalho-2 = trim(return-value).
{utp/ut-liter.i Bomba * R }
assign  cBomba:label in frame f-cabecalho-2 = trim(return-value).
{utp/ut-liter.i Material * R }
assign  cMaterial:label in frame f-cabecalho-2 = trim(return-value).
{utp/ut-liter.i Documento * R }
assign  cDocto:label in frame f-cabecalho-2 = trim(return-value).
{utp/ut-liter.i Inicial * R }
assign  cValIni-1:label in frame f-cabecalho-2 = trim(return-value).
{utp/ut-liter.i Final * R }
assign    cValFim-1:label in frame f-cabecalho-2 = trim(return-value).
{utp/ut-liter.i Qtde * R }
assign    cQtde-1:label in frame f-cabecalho-2 = trim(return-value).
{utp/ut-liter.i Data * R }
assign    cData:label in frame f-cabecalho-2 = trim(return-value).
{utp/ut-liter.i Hora * R }
assign    cHora:label in frame f-cabecalho-2 = trim(return-value).
{utp/ut-liter.i Posto_Orig * R }
assign    cPstOrig:label in frame f-cabecalho-2 = trim(return-value).
{utp/ut-liter.i Posto_Dest * R }
assign    cPstDest:label in frame f-cabecalho-2 = trim(return-value).

form    cPstOrig        AT 01  
        cTpApont        AT 12  
        cDocto          AT 29  
        cData           AT 39  
        cHora           AT 50  
        cBomba          AT 57  
        cMaterial       AT 66   
        cValIni-1       AT 83   
        cValFim-1       AT 97   
        cQtde-1         AT 111  
        cPstDest        AT 125  FORMAT "x(07)"
        with no-box  width 132 frame f-cabecalho-3 stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cabecalho-3:HANDLE).


form   mab-control-bomba.cod-posto-orig       NO-LABEL  AT 01 
       cApont                                 NO-LABEL  AT 12   format "x(16)"                                      
       mab-control-bomba.num-docto            NO-LABEL  AT 29   FORMAT ">>>>>>>9"                     
       mab-control-bomba.dat-apont            NO-LABEL  AT 39                                          
       mab-control-bomba.hra-apont            NO-LABEL  AT 50   FORMAT "99:99"                         
       mab-control-bomba.cod-bomba            NO-LABEL  AT 57   FORMAT "X(08)"                                      
       mab-tip-mater.des-tip-mater            NO-LABEL  AT 66   format "x(16)"                         
       mab-control-bomba.val-leitura-inicial  NO-LABEL  AT 83   FORMAT ">>,>>>,>>9.99"                      
       mab-control-bomba.val-leitura-final    NO-LABEL  AT 97   FORMAT ">>,>>>,>>9.99"                 
       mab-control-bomba.val-quant            NO-LABEL  AT 111  FORMAT ">>,>>>,>>9.99"                    
       mab-control-bomba.cod-posto-dest       NO-LABEL  AT 125  FORMAT "x(07)"                         
        with no-box  width 132 frame f-dados-3 stream-io. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-dados-3:HANDLE).
                                            
                                                                                                                     
{utp/ut-liter.i Tipo * R }
assign  cTpApont:label in frame f-cabecalho-3 = trim(return-value).
{utp/ut-liter.i Bomba * R }
assign  cBomba:label in frame f-cabecalho-3 = trim(return-value).
{utp/ut-liter.i Material * R }
assign  cMaterial:label in frame f-cabecalho-3 = trim(return-value).
{utp/ut-liter.i Documento * R }
assign  cDocto:label in frame f-cabecalho-3 = trim(return-value).
{utp/ut-liter.i Inicial * R }
assign  cValIni-1 :label in frame f-cabecalho-3 = trim(return-value).
{utp/ut-liter.i Final * R }
assign    cValFim-1:label in frame f-cabecalho-3 = trim(return-value).
{utp/ut-liter.i Qtde * R }
assign    cQtde-1:label in frame f-cabecalho-3 = trim(return-value).
{utp/ut-liter.i Data * R }
assign    cData:label in frame f-cabecalho-3 = trim(return-value).
{utp/ut-liter.i Hora * R }
assign    cHora:label in frame f-cabecalho-3 = trim(return-value).
{utp/ut-liter.i Posto_Orig * R }
assign    cPstOrig:label in frame f-cabecalho-3 = trim(return-value).
{utp/ut-liter.i Posto_Des * R }
assign    cPstDest:label in frame f-cabecalho-3 = trim(return-value).

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
        field l-afericoes          as logical 
        field l-transf             as logical 
        field l-leitura            as logical 
        field l-Insere             as logical 
        field d-data-ini           like mab-control-bomba.dat-apont
        field d-data-fim           like mab-control-bomba.dat-apont
        field c-hora-ini           like mab-control-bomba.hra-apont
        field c-hora-fim           like mab-control-bomba.hra-apont
        field c-posto-ini          like mab-posto.cod-posto
        field c-posto-fim          like mab-posto.cod-posto
        field i-docto-ini          like mab-movto-event.num-docto
        field i-docto-fim          like mab-movto-event.num-docto.
        
def temp-table tt-digita no-undo
    field linha      as integer
    field conteudo   as character format "x(80)"
    index editor-id is primary unique linha.
