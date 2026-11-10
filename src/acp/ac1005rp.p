/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1005RP 2.00.00.029 } /*** "010029" 28/02/2025 09:42:30  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1005rp MAC}
&ENDIF

/*******************************************************************************
**
**   Programa: ac1005rp.p
**   Autor...: Datasul S/A.
**   Objetivo: Rotina para Exporta‡Æo de Cotas  
**   Data....: Julho de 1997
*********************************************************************************/
{utp/ut-glob.i}
/* ********************  Defini‡Æo de Temp-Table ****************************** */

/* Temporary Table Definitions ---                                      */

/* Include pre-processador release 202 ou 203 */
{cdp/cdcfgdis.i}

{acp/ac9000.i} 

define temp-table tt-param
    field destino          as   integer
    field arquivo          as   character
    field arq-destino      as   character
    field arq-entrada      as   character format "x(40)"
    field exporta          as   integer
    field desc-exporta     as   character format "x(40)"
    field usuario          as   character
    field data-exec        as   date
    field hora-exec        as   integer
    field cod-estab-ini    like cotas.cod-estab
    field cod-estab-fim    like cotas.cod-estab
    field canal-venda-ini  like cotas.cod-canal-venda
    field canal-venda-fim  like cotas.cod-canal-venda
    field grupo-cli-ini    like cotas.cod-gr-cli
    field grupo-cli-fim    like cotas.cod-gr-cli
    field nome-abrev-ini   like cotas.nome-abrev
    field nome-abrev-fim   like cotas.nome-abrev
    field nome-ab-reg-ini  like cotas.nome-ab-reg
    field nome-ab-reg-fim  like cotas.nome-ab-reg
    field nome-mic-reg-ini like cotas.nome-mic-reg
    field nome-mic-reg-fim like cotas.nome-mic-reg
    field cod-rep-ini      like cotas.cod-rep
    field cod-rep-fim      like cotas.cod-rep
    field produto-ini      like cotas.cd-produto
    field produto-fim      like cotas.cd-produto
    field data-ini         like cotas.dt-inicial
    field data-fim         like cotas.dt-inicial
    field cod-estabel-ini  like cotas.cod-estabel
    field cod-estabel-fim  like cotas.cod-estabel.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Include com defini‡äes das temp-tables */   
{utp/utapi003.i}

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* ************************ Defini‡Æo de Vari veis ************************** */

{include/i-rpvar.i}        

def var h-acomp            as   handle                    no-undo.
def var c-selecao          as   character format "x(11)"  no-undo.
def var c-parametro        as   character format "x(14)"  no-undo.
def var c-impressao        as   character format "x(12)"  no-undo.
def var c-destino          as   character format "x(10)"  no-undo.
def var c-exporta          as   character format "x(30)"  no-undo.
def var c-descricao        as   character format "x(9)"   no-undo.
def var c-previsto         as   character format "x(8)"   no-undo.
def var c-pedido           as   character format "x(6)"   no-undo.
def var c-ped-liq          as   character format "x(3)"   no-undo.
def var c-faturado         as   character format "x(8)"   no-undo.
def var c-cancelado        as   character format "x(10)"  no-undo.
def var c-codigo           as   character format "x(13)"  no-undo.
def var c-fat-canc         as   character format "x(9)"   no-undo.
def var c-suspensos        as   character format "x(9)"   no-undo.
def var c-fat-liq          as   character format "x(3)"   no-undo.
def var de-tot-prev        like cotas.qt-prevista         no-undo.
def var de-tot-ped         like cotas.qt-pedida           no-undo.
def var de-tot-fat         like cotas.qt-faturada         no-undo.
def var de-tot-fat-canc    like cotas.qt-faturada         no-undo.
def var de-tot-ped-canc    like cotas.qt-faturada         no-undo.
def var de-tot-susp-canc   like cotas.qt-faturada         no-undo.
def var c-total            as   character                 no-undo.
def var c-ped-canc         as   character format "x(16)"  no-undo.
def var l-european-format  as   logical                   no-undo.

/* ************************* Defini‡Æo de Stream ***************************** */

def stream s-exporta.

/* ************************** Defini‡Æo de Form ****************************** */

form skip(01)
     c-selecao   no-label    skip(1)
     &IF "{&mguni_version}" >= "2.071" &THEN
     tt-param.cod-estabel-ini            colon 40 space(12) "|< >|"
     &ELSE
     tt-param.cod-estabel-ini            colon 40 space(14) "|< >|"
     &ENDIF
     tt-param.cod-estabel-fim         no-label colon 73 skip
     tt-param.canal-venda-ini            colon 40 space(14) "|< >|"
     tt-param.canal-venda-fim         no-label colon 73 skip
     tt-param.nome-ab-reg-ini            colon 40 space(05) "|< >|"
     tt-param.nome-ab-reg-fim         no-label colon 73 skip
     tt-param.nome-mic-reg-ini           colon 40 space(05) "|< >|"
     tt-param.nome-mic-reg-fim        no-label colon 73 skip
     tt-param.cod-rep-ini                colon 40 space(12) "|< >|"
     tt-param.cod-rep-fim             no-label colon 73 skip
     tt-param.produto-ini                colon 40 space(1)  "|< >|"
     tt-param.produto-fim             no-label colon 73 skip
     tt-param.data-ini                   colon 40 space(7)  "|< >|"
     tt-param.data-fim                no-label colon 73 skip
     c-parametro no-label                               skip(1)
     tt-param.desc-exporta               colon 40
     tt-param.arq-entrada                colon 40       skip(1)
     c-impressao no-label                               skip(1)
     c-destino                           colon 40
     " - ":U
     tt-param.arq-destino no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros.

/* ****************************** Literais ********************************** */

{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).

{utp/ut-liter.i PAR¶METROS * R}
assign c-parametro = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).


{utp/ut-liter.i Exporta_para * L}
assign tt-param.desc-exporta:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Arquivo_Sa¡da * L}
assign tt-param.arq-entrada:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Descri‡Æo * R}
assign c-descricao = trim(return-value).

{utp/ut-liter.i Previsto * R}
assign c-previsto = trim(return-value).

{utp/ut-liter.i Pedido * R}
assign c-pedido = trim(return-value).

{utp/ut-liter.i Pedido_Cancelado * R}
assign c-ped-canc = trim(return-value).

{utp/ut-liter.i Faturado * R}
assign c-faturado = trim(return-value).

{utp/ut-liter.i Cancelados * R}
assign c-cancelado = trim(return-value).

{utp/ut-liter.i Cancelado * R}
assign c-fat-canc = trim(return-value).

{utp/ut-liter.i Produto/Item * R}
assign c-codigo = trim(return-value).

{utp/ut-liter.i Total * R}
assign c-total = trim(return-value).

{utp/ut-liter.i Exporta‡Æo_Cotas MCT C}  
assign c-titulo-relat = return-value.


{utp/ut-liter.i Produto/Item * R}
assign tt-param.produto-ini:LABEL IN FRAM f-parametros = trim(return-value).

/* ************************************************************************* */
run utp/ut-trfrrp.p (input frame f-parametros:handle).
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param.
assign tt-param.arquivo =  tt-param.arq-destino.

/*
** Verificar formato num‚rico para defini‡Æo formato das c‚lulas
*/
if session:numeric-format = "EUROPEAN":U then
    assign l-european-format = yes.
else
    assign l-european-format = no.

find empresa 
     where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.

{utp/ut-liter.i Cotas MCT L}                 
assign c-programa = "AC/1005"
       c-empresa  = empresa.razao-social
       c-sistema  = return-value
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Exporta‡Æo de Cotas...").         

if tt-param.exporta = 1 then
  run pi-exporta-arquivo.
else 
  run pi-exporta-excel.

run pi-finalizar in h-acomp. 

/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.
display c-selecao 
        tt-param.cod-estabel-ini
        tt-param.cod-estabel-fim
        tt-param.canal-venda-ini   
        tt-param.canal-venda-fim   
        tt-param.nome-ab-reg-ini    
        tt-param.nome-ab-reg-fim    
        tt-param.nome-mic-reg-ini     
        tt-param.nome-mic-reg-fim    
        tt-param.cod-rep-ini      
        tt-param.cod-rep-fim      
        tt-param.produto-ini   
        tt-param.produto-fim  
        tt-param.data-ini
        tt-param.data-fim
        c-parametro
        tt-param.desc-exporta
        tt-param.arq-entrada
        c-impressao
        c-destino
        tt-param.arq-destino        
        tt-param.usuario
        with frame f-parametros.

{include/i-rpclo.i}

Return "OK".
/*fim-do-programa*/

/*****************************************************************/
/* *********** Procedure de exporta‡Æo para arquivo ************ */
/*****************************************************************/
Procedure pi-exporta-arquivo:

output stream s-exporta to value(tt-param.arq-entrada).
main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:

    for each cotas no-lock 
        where   cotas.cod-estabel     >= tt-param.cod-estabel-ini
        and     cotas.cod-estabel     <= tt-param.cod-estabel-fim
        and   ((cotas.cod-canal-venda >= tt-param.canal-venda-ini
        and     cotas.cod-canal-venda <= tt-param.canal-venda-fim)
        or      cotas.cod-canal-venda  = ?)
        and   ((cotas.cod-gr-cli      >= tt-param.grupo-cli-ini
        and     cotas.cod-gr-cli      <= tt-param.grupo-cli-fim)
        or      cotas.cod-gr-cli       = ?)
        and   ((cotas.nome-abrev      >= tt-param.nome-abrev-ini
        and     cotas.nome-abrev      <= tt-param.nome-abrev-fim)
        or      cotas.nome-abrev       = ?)
        and   ((cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
        and     cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
        or      cotas.nome-ab-reg      = ?)
        and   ((cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
        and     cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim)
        or      cotas.nome-mic-reg     = ?)
        and    (cotas.cod-rep         >= tt-param.cod-rep-ini
        and     cotas.cod-rep         <= tt-param.cod-rep-fim
        and     cotas.cod-rep         <> ?) /*release 203*/
        and     cotas.cd-produto      >= tt-param.produto-ini
        and     cotas.cd-produto      <= tt-param.produto-fim
        and     cotas.dt-inicial      >= tt-param.data-ini
        and     cotas.dt-inicial      <= tt-param.data-fim
        break by cotas.cod-estabel
              by cotas.cod-rep
              by cotas.cd-produto:

        if first-of(cotas.cod-estabel) or
           first-of(cotas.cod-rep) then do:

           if LINE-COUNTER >= 54 then page.

           find estabelec no-lock
                where estabelec.cod-estabel = cotas.cod-estabel no-error.
           if avail estabelec then
                disp cotas.cod-estabel       at 01 
                     "-"                     at 27
                     estabelec.nome no-label at 30
                     skip
                     with width 132 side-labels no-attr stream-io frame f-representante.
           find repres no-lock
                where repres.cod-rep = cotas.cod-rep no-error.
           if avail repres then
              disp cotas.cod-rep at 03 
                   repres.nome no-label at 26 
              skip(1)
                   with width 132 side-labels frame f-representante.

           put c-codigo     at 01
               c-descricao  at 18
               c-previsto   at 43
               c-pedido     at 63
               c-ped-canc   at 71
               c-faturado   at 97
               c-fat-canc   at 114

               "----------------"  at 01
               "---------------"   at 18 
               "-----------------" at 34
               "-----------------" at 52
               "-----------------" at 70
               "-----------------" at 88
               "-----------------" at 106 
               skip.
        end.

        {acp/ac9001.i &param-cota=no} 

        put cotas.cd-produto at 01. 

        &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
          find first produto-coml no-lock where
                     produto-coml.cod-produto-coml = cotas.cd-produto no-error.
          if avail produto-coml then 
             put  produto-coml.des-produto-coml format "x(15)" at 18.
          if not avail produto-coml then do:
        &else
          find first produto no-lock where
                     produto.cd-produto = cotas.cd-produto no-error.
          if avail produto then 
             put  produto.descricao format "x(15)" at 18.
          if not avail produto then do:
        &endif

             for first item fields(desc-item) no-lock where
                       item.it-codigo = cotas.cd-produto :
                 put item.desc-item format "x(15)" at 18 .
             end.
          end.   

        if avail tt-cotas then do:
            put  tt-cotas.prevista  at 34
                 tt-cotas.pedida    at 52
                 tt-cotas.ped-canc  at 70
                 tt-cotas.faturada  at 88 format "->>>>,>>>,>>9.9999"
                 tt-cotas.fat-canc  at 106.
            assign de-tot-prev      = de-tot-prev     + tt-cotas.prevista
                   de-tot-ped       = de-tot-ped      + tt-cotas.pedida
                   de-tot-ped-canc  = de-tot-ped-canc + tt-cotas.ped-canc
                   de-tot-fat       = de-tot-fat      + tt-cotas.faturada 
                   de-tot-fat-canc  = de-tot-fat-canc + tt-cotas.fat-canc.
            delete tt-cotas.
        end.  

        if last-of(cotas.cod-rep) then do:
           if LINE-COUNTER > 57 then page.
           put  "-----------------" at 34
                "-----------------" at 52
                "-----------------" at 70
                "-----------------" at 88
                "-----------------" at 106
                c-total             at 17
                de-tot-prev         at 34
                de-tot-ped          at 52
                de-tot-ped-canc     at 70
                de-tot-fat          at 88 format "->>>>,>>>,>>9.9999"
                de-tot-fat-canc     at 106.     
           assign de-tot-prev      = 0
                  de-tot-ped       = 0
                  de-tot-fat       = 0
                  de-tot-susp-canc = 0
                  de-tot-fat-canc  = 0.

        end.                      
        run pi-acompanhar in h-acomp (input cotas.cd-produto ).

        /* EXPORTA COTAS */
        put stream s-exporta
            space(3)
            cotas.cod-canal-venda      format "999"   
            cotas.cd-produto           format "x(16)"     
            space(2)                   
            cotas.nome-abrev           format "x(12)"
            cotas.nome-ab-reg          format "x(12)"   
            cotas.nome-mic-reg         format "x(12)"   
            cotas.cod-rep              format "99999"   
            cotas.dt-inicial           format "99999999"
            cotas.dt-final             format "99999999"
            cotas.cota-liberada        format "S/N"
            cotas.qt-prevista   * 100  format "999999999999" 
            cotas.qt-pedida     * 100  format "999999999999"
            cotas.qt-faturada   * 100  format "999999999999"
            cotas.qt-ped-canc   * 100  format "999999999999"
            cotas.qt-fat-canc   * 100  format "999999999999"
            cotas.qt-ped-susp   * 100  format "999999999999"
            cotas.qt-original   * 100  format "999999999999"
            cotas.qt-solicitado * 100  format "999999999999"
            /*****  Uso de pre-processador ******/
            &if defined (bf_dis_adm_cotas) &then  
            cotas.qt-ped-reprov * 100  format "999999999999"
            &endif                        
            cotas.vl-previsto   * 100  format "999999999999"
            cotas.vl-pedido     * 100  format "999999999999"
            cotas.vl-faturado   * 100  format "999999999999"
            cotas.vl-ped-canc   * 100  format "999999999999"
            cotas.vl-fat-canc   * 100  format "999999999999"
            cotas.vl-ped-susp   * 100  format "999999999999"
            cotas.vl-original   * 100  format "999999999999"
            cotas.vl-solicitado * 100  format "999999999999"
            /*****  Uso de pre-processador ******/
            &if defined (bf_dis_adm_cotas) &then  
            cotas.vl-ped-reprov * 100  format "999999999999"
            &endif   
            &if "{&mguni_version}" >= "2.071" &THEN
            cotas.cod-estabel          format "x(05)"
            &else
            cotas.cod-estabel          format "xxx"
            &endif  
            cotas.cod-gr-cli           format "9999"                   
            skip.  
    end.
end.    

output stream s-exporta close.
end procedure.

/************************************************************/
/* ********** Procedure de exporta‡Æo para excel ********** */
/************************************************************/
Procedure pi-exporta-excel:

  define var c-empresa    as char.
  define var i-cont-colun as integer.
  define var i-linha as integer init 1.
  define var c-titulo-planilha       as character. 
  DEFINE VARIABLE c-dir AS CHARACTER   NO-UNDO.

  ASSIGN c-dir = SESSION:TEMP-DIRECTORY + tt-param.usuario + "/".
  OS-CREATE-DIR VALUE(c-dir).
    IF OS-ERROR <> 0 THEN
        ASSIGN c-dir = session:TEMP-DIRECTORY.
   
   create tt-configuracao.
   assign tt-configuracao.versao-integracao   = 2
          tt-configuracao.arquivo-num         = 1
          tt-configuracao.arquivo             = c-dir + "ac1005.xls"
          tt-configuracao.total-planilhas     = 1
          tt-configuracao.exibir-construcao   = no
          tt-configuracao.abrir-excel-termino = yes.

   create tt-planilha.
   assign tt-planilha.arquivo-num  = 1
          tt-planilha.planilha-num = 1.

   {utp/ut-liter.i Planilha_Cotas MAC C}
   assign tt-planilha.planilha-nome     = return-value
          tt-planilha.formatar-planilha = yes
          tt-planilha.largura-coluna    = 12
          tt-planilha.linhas-grade      = yes.

   find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
   if  avail empresa then 
       assign c-empresa = empresa.razao-social.

   /*Cabe‡alho*/

   create tt-dados.
   assign tt-dados.arquivo-num   = 1
          tt-dados.planilha-num  = 1
          tt-dados.celula-coluna = 1
          tt-dados.celula-linha  = 1
          tt-dados.celula-valor  = c-empresa.

   create tt-dados.
   assign tt-dados.planilha-num  = 1

          &if defined (bf_dis_adm_cotas) &then  
              tt-dados.celula-coluna = 20
          &else
              tt-dados.celula-coluna = 19
          &endif

          tt-dados.celula-linha  = 02
          tt-dados.celula-valor  = string(today)
          tt-dados.celula-alinhamento-horizontal = 05.

   {utp/ut-liter.i Cotas_de_Itens_por_Representantes MAC C}
   create tt-dados.
   assign tt-dados.planilha-num  = 01
          tt-dados.celula-coluna = 10
          tt-dados.celula-linha  = 03
          tt-dados.celula-valor  = return-value
          tt-dados.celula-alinhamento-horizontal = 01
          tt-dados.celula-fonte-tamanho          = 12.

   &if defined (bf_dis_adm_cotas) &then  
   /*Titulos das Colunas*/
   do i-cont-colun = 1 to 20:
   &else
   /*Titulos das Colunas*/
   do i-cont-colun = 1 to 19:
   &endif                                

      if i-cont-colun = 01 then
        {utp/ut-field.i mgdis cotas cod-estabel 2}
      if i-cont-colun = 02 then
        {utp/ut-field.i mgdis cotas cod-canal-venda 1}
      if i-cont-colun = 03 then
        {utp/ut-field.i mgdis canal-venda descricao 1}
      if i-cont-colun = 04 then
        {utp/ut-field.i mgdis cotas cod-gr-cli 1}
      if i-cont-colun = 05 then
        {utp/ut-field.i mgadm gr-cli descricao 1}
      if i-cont-colun = 06 then
        {utp/ut-field.i mgdis cotas nome-abrev 1}
      if i-cont-colun = 07 then
        {utp/ut-field.i mgdis cotas nome-ab-reg 1}
      if i-cont-colun = 08 then
        {utp/ut-field.i mgdis cotas nome-mic-reg 1}
      if i-cont-colun = 09 then
        {utp/ut-field.i mgadm repres cod-rep 1}
      if i-cont-colun = 10 then
        {utp/ut-field.i mgadm repres nome 1}
      if i-cont-colun = 11 then
        {utp/ut-liter.i Produto/Item * R}
      if i-cont-colun = 12 then
        {utp/ut-field.i mgind item desc-item 1}
      if i-cont-colun = 13 then
        {utp/ut-field.i mgdis cotas dt-inicial 1}
      if i-cont-colun = 14 then
        {utp/ut-field.i mgdis cotas dt-final 1}
      if i-cont-colun = 15 then
        {utp/ut-field.i mgdis cotas qt-prevista 1}
      if i-cont-colun = 16 then
        {utp/ut-field.i mgdis cotas qt-pedida 1}
      if i-cont-colun = 17 then
        {utp/ut-field.i mgdis cotas qt-faturada 1}
      if i-cont-colun = 18 then
        {utp/ut-field.i mgdis cotas qt-original 1}
      if i-cont-colun = 19 then
        {utp/ut-field.i mgdis cotas qt-solicitado 1}

      /*****  Uso de pre-processador ******/
      &if defined (bf_dis_adm_cotas) &then  
          if i-cont-colun = 20 then
             {utp/ut-field.i mgdis cotas qt-ped-reprov 1}
      &endif                                

        create tt-dados.
        assign tt-dados.planilha-num                  = 1
               tt-dados.celula-coluna                 = i-cont-colun
               tt-dados.celula-linha                  = 05
               tt-dados.celula-cor-interior           = 18
               tt-dados.celula-valor                  = return-value
               tt-dados.celula-alinhamento-horizontal = if i-cont-colun >= 12 then 05 else 03
               tt-dados.celula-fonte-negrito          = yes
               tt-dados.celula-fonte-cor              = 02
               tt-dados.celula-tipo-borda-sup         = 06
               tt-dados.celula-tipo-borda-inf         = 06
               tt-dados.celula-tipo-borda-esq         = 06
               tt-dados.celula-tipo-borda-dir         = 06.                    

  end.    

  assign i-linha = 5.

  /*Dados de Cotas*/

    for each cotas no-lock
       where (cotas.cod-estabel     >= tt-param.cod-estab-ini
       and     cotas.cod-estabel     <= tt-param.cod-estab-fim)
       and   ((cotas.cod-canal-venda >= tt-param.canal-venda-ini
       and     cotas.cod-canal-venda <= tt-param.canal-venda-fim)
       or      cotas.cod-canal-venda  = ?)
       and   ((cotas.cod-gr-cli      >= tt-param.grupo-cli-ini
       and     cotas.cod-gr-cli      <= tt-param.grupo-cli-fim)
       or      cotas.cod-gr-cli       = ?)
       and   ((cotas.nome-abrev      >= tt-param.nome-abrev-ini
       and     cotas.nome-abrev      <= tt-param.nome-abrev-fim)
       or      cotas.nome-abrev       = ?)
       and   ((cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
       and     cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
       or      cotas.nome-ab-reg      = ?)
       and   ((cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
       and     cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim)
       or      cotas.nome-mic-reg     = ?)
       and    (cotas.cod-rep         >= tt-param.cod-rep-ini
       and     cotas.cod-rep         <= tt-param.cod-rep-fim
       AND     cotas.cod-rep         <> ?)
       and     cotas.cd-produto      >= tt-param.produto-ini
       and     cotas.cd-produto      <= tt-param.produto-fim
       and     cotas.dt-inicial      >= tt-param.data-ini
       and     cotas.dt-inicial      <= tt-param.data-fim:

       assign i-linha = i-linha + 1.

       {acp/ac9001.i &param-cota=no}

       &if defined (bf_dis_adm_cotas) &then  
       do i-cont-colun = 1 to 20:
       &else
       do i-cont-colun = 1 to 19:
       &endif

          create tt-dados.
          assign tt-dados.planilha-num          = 01
                 tt-dados.celula-coluna         = i-cont-colun
                 tt-dados.celula-linha          = i-linha
                 tt-dados.celula-cor-interior   = 15
                 tt-dados.celula-tipo-borda-sup = 01
                 tt-dados.celula-tipo-borda-inf = 01
                 tt-dados.celula-tipo-borda-esq = 01
                 tt-dados.celula-tipo-borda-dir = 01.                    

          if i-cont-colun = 01 then
             assign  tt-dados.celula-valor = cotas.cod-estabel.
                     tt-dados.celula-formato = "@".

          if i-cont-colun = 02 then
             assign  tt-dados.celula-valor = string(cotas.cod-canal-venda).

          if i-cont-colun = 03 then do:
             find canal-venda no-lock
                  where canal-venda.cod-canal-venda = cotas.cod-canal-venda no-error.
             assign tt-dados.celula-valor  = if avail canal-venda then canal-venda.descricao else "".
          end.  

          if i-cont-colun = 04 then
             assign tt-dados.celula-valor  = string(cotas.cod-gr-cli).

          if i-cont-colun = 05 then do:
             find gr-cli no-lock
                  where gr-cli.cod-gr-cli = cotas.cod-gr-cli no-error.
             assign tt-dados.celula-valor = if avail gr-cli then gr-cli.descricao else "".
          end.   

          if i-cont-colun = 06 then do:
             assign tt-dados.celula-valor = cotas.nome-abrev.
          end.   

          if i-cont-colun = 07 then 
            assign tt-dados.celula-valor  = cotas.nome-ab-reg.

          if i-cont-colun = 08 then 
            assign tt-dados.celula-valor  = cotas.nome-mic-reg.

          if i-cont-colun = 09 then 
            assign tt-dados.celula-valor  = string(cotas.cod-rep).

          if i-cont-colun = 10 then do:
             find repres no-lock
                  where repres.cod-rep    = cotas.cod-rep no-error.
             if avail repres then
                assign tt-dados.celula-valor = repres.nome.
          end.   

          if i-cont-colun = 11 then
              assign tt-dados.celula-formato = "@"
                     tt-dados.celula-valor = cotas.cd-produto.

          if i-cont-colun = 12 then do:

             &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
               find first produto-coml no-lock where
                          produto-coml.cod-produto-coml = cotas.cd-produto no-error.
               if avail produto-coml then 
                  assign tt-dados.celula-valor = produto-coml.des-produto-coml.
               if not avail produto-coml then do:
             &else
               find first produto no-lock where
                          produto.cd-produto = cotas.cd-produto no-error.
               if avail produto then 
                  assign tt-dados.celula-valor = produto.descricao.
               if not avail produto then do:
             &endif
                  for first item fields(desc-item) no-lock where
                            item.it-codigo = cotas.cd-produto :
                      assign tt-dados.celula-valor = ITEM.desc-item.
                  end.
               end.   
          end.   

          if i-cont-colun = 13 then 
             assign tt-dados.celula-valor        = string(cotas.dt-inicial)
                    tt-dados.celula-formato = "@"
                    tt-dados.celula-alinhamento-horizontal = 05.

          if i-cont-colun = 14 then 
             assign tt-dados.celula-valor        = string(cotas.dt-final)
                    tt-dados.celula-formato = "@"
                    tt-dados.celula-alinhamento-horizontal = 05.

          if i-cont-colun = 15 then
             assign tt-dados.celula-valor        = if avail tt-cotas then string(tt-cotas.prevista) else "":U.

          if i-cont-colun = 16 then 
             assign tt-dados.celula-valor        = if avail tt-cotas then string(tt-cotas.pedida) else "":U.

          if i-cont-colun = 17 then 
             assign tt-dados.celula-valor        = if avail tt-cotas then string(tt-cotas.faturada)  else "":U.

          if i-cont-colun = 18 then 
             assign tt-dados.celula-valor        = if avail tt-cotas then string(tt-cotas.original)  else "":U.

          if i-cont-colun = 19 then 
             assign tt-dados.celula-valor        = if avail tt-cotas then string(tt-cotas.solicitado)  else "":U.

          if i-cont-colun = 15 or
             i-cont-colun = 16 or
             i-cont-colun = 17 or
             i-cont-colun = 18 or
             i-cont-colun = 19 then do:
             if l-european-format then
                assign tt-dados.celula-formato = "##.###.##0,00_);(##.###.##0,00)".
             else
                assign tt-dados.celula-formato = "##,###,##0.00_);(##,###,##0.00)".
             assign tt-dados.celula-alinhamento-horizontal = 05.             
          end.                                 

          /*****  Uso de pre-processador ******/
          &if defined (bf_dis_adm_cotas) &then  
              if i-cont-colun = 20 then 
                 assign tt-dados.celula-valor        = if avail tt-cotas then string(tt-cotas.reprovada)  else "":U.

              if i-cont-colun = 20 then do:
                 if l-european-format then
                    assign tt-dados.celula-formato = "##.###.##0,00_);(##.###.##0,00)".
                 else
                    assign tt-dados.celula-formato = "##,###,##0.00_);(##,###,##0.00)".
                 assign tt-dados.celula-alinhamento-horizontal = 05.
              end.

          &endif

       end.            
       if avail tt-cotas then 
          delete tt-cotas.
   end.

   /*Rodap‚*/

   {utp/ut-liter.i Cotas MAC C}
   create tt-dados.
   assign tt-dados.planilha-num  = 01
          tt-dados.celula-coluna = 18
          tt-dados.celula-linha  = i-linha + 1
          tt-dados.celula-valor  = return-value + " -  " + "DATASUL S.A."
          tt-dados.celula-alinhamento-horizontal = 01
          tt-dados.celula-fonte-tamanho          = 12.


   run utp/utapi003.p (input-output table tt-configuracao,
                       input-output table tt-planilha,
                       input-output table tt-dados,
                       input-output table tt-grafico,
                       input-output table tt-erros).

   if return-value = "NOK" then do:
      for each tt-erros:
          run utp/ut-msgs.p (input "show",
                             input tt-erros.cod-erro,  
                             input "").
          return 'no-apply'.
      end. 
   end.

   for each tt-configuracao exclusive-lock:
       delete tt-configuracao.
   end.
   for each tt-planilha exclusive-lock:
       delete tt-planilha.
   end.
   for each tt-dados exclusive-lock:
       delete tt-dados.
   end.
   for each tt-grafico exclusive-lock:
       delete tt-grafico.
   end.
   for each tt-erros exclusive-lock:
       delete tt-erros.
   end.

end procedure.
