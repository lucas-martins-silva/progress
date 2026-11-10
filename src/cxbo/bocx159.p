/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX159 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX159 MUT}
&ENDIF

/**************************************************************************
**
**  BOCX159.P - Cancela, Reativa e Suspende Pedidos de Venda (BODI159.P).
**              Este programa Ç utilizado somente na ingegraá∆o Exportaá∆o
**              EMS com o produto Magnus.
*/
/******************************ATENCAO*************************************
-  Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-dis-comex) &then ), significa que o produto
 chamador e o Magnus se n∆o, EMS. Utilizado pelo produto Comercio Exterior
- Include com pre-processadores que diferenciam releases 
**************************************************************************/ 
{cdp/cdcfgdis.i} /* Definicao de pre-processadores - Magnus ou EMS */

&IF DEFINED(bf-dis-comex) &THEN
 
    /** necessario para chamada da api pdapi152.p */
    {cdp/cdapi300.i1}  /* Temp-Table de Erros   */
    {pdp/pdapi151.i}   /* Temp-Table Ped-Venda   */                     
    {pdp/pdapi151.i2}  /* Temp-Table Ped-Repre   */                     
    {pdp/pdapi151.i4}  /* Temp-Table Con-Pges    */    
    {pdp/pdapi151.i5}  /* Temp-Table Ped-Antecip */
    {pdp/pdapi151.i6}  /* Temp-Table Pd-vendor   */
    {cdp/cdapi150.i3}  /* Temp-Table de Vers„o   */
    {cdp/cdapi150.i4}  /* Temp-Table de Erros    */
    {exp/exapi152.i}   /* Temp-Table Ped-Item/Ped-Ent */
    
    {utp/ut-glob.i}
    
    def var i-cod-maq-origem like tt-erros-geral.cod-maq-origem no-undo.
    def var i-num-processo   like tt-erros-geral.num-processo   no-undo.
    def var c-param          as char no-undo.
    
    &scoped-define BOVERSION 1.1
    &scoped-define FIRST-TABLE-IN-QUERY ped-venda
    &scoped-define QUERY-NAME qTable
    &scoped-define TABLE-NAME ped-venda
    &scoped-define PARENT-TABLE repres
    {include/boini.i}
     
    {dibo/bodi159.i rowObject}
     
    DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
    
    {include/bostrmet.i}
    {include/boendmet.i}
    {include/bonav.i}
    {include/bofind.i}
    {include/bosetcur.i}
    {include/bogetcur.i}
    {include/bosersen.i}
    {include/boprebro.i}
    def new global shared var c-seg-usuario as char format "x(12)" no-undo.
    
    procedure pedVendaSuspendePedido:
       /* 
       ** Suspende um ped-venda 
       ** Pedido de Venda
       */
       def input parameter table for rowObject.
       def output parameter table for tt-bo-erro.
       
       find first rowObject no-error.
       run startMethod ("pedVendaSuspendePedido").
       find first tt-bo-erro
           no-lock no-error.
       if avail tt-bo-erro then return.    
    
       run pedVendaCallApi (input 5). 
       run endMethod ("pedVendaSuspendePedido").
    
    end procedure.
           
    procedure pedVendaReativaPedido:
       /* 
       ** Reativa um ped-venda previamente suspenso 
       ** Pedido de Venda
       */
       def input parameter table for rowObject.
       def output parameter table for tt-bo-erro.
       find first rowObject no-error.
       run startMethod ("pedVendaReativaPedido").
       find first tt-bo-erro
           no-lock no-error.
       if avail tt-bo-erro then return.    
    
       run pedVendaCallApi (input 6).
       run endMethod ("pedVendaReativaPedido").
    
    end procedure.
    
    procedure pedVendaCancelaPedido:
       /* 
       ** Cancela um ped-venda 
       ** Pedido de Venda
       */
       def input parameter table for rowObject.
       def output parameter table for tt-bo-erro.
       find first rowObject no-error.
       run startMethod ("pedVendaCancelaPedido").
       find first tt-bo-erro
           no-lock no-error.
       if avail tt-bo-erro then return.    
    
       run pedVendaCallApi (input 7).
       run endMethod ("pedVendaCancelaPedido").
       
    end procedure.
    
    procedure pedVendaCallApi:
       /* 
       ** Chamada da api pdapi152.p 
       ** Pedido de Venda
       */
       def input parameter i-ind-tipo-movto as integer.
       def var i-seq-erro as integer no-undo.
       create tt-versao-integr.
       assign tt-versao-integr.cod-versao-integracao = 001
              tt-versao-integr.ind-origem-msg        = 01.
       find first rowObject no-error.
       create tt-ped-venda.
       buffer-copy rowObject except r-rowid to tt-ped-venda.
       assign tt-ped-venda.ind-tipo-movto = i-ind-tipo-movto. 
       for each tt-ped-repre:
           assign tt-ped-repre.ind-tipo-movto = 1
                  tt-ped-repre.char-1         = tt-ped-venda.nome-abrev.
       end.
        
       run exp/exapi152.p (input-output table tt-ped-venda,
                           input-output table tt-ped-item, 
                           input-output table tt-ped-ent,
                           input-output table tt-ped-repre,
                           input-output table tt-con-pges,
                           input-output table tt-ped-antecip,
                           input-output table tt-versao-integr,
                           output       table  tt-erros-geral, 
                           input        i-cod-maq-origem,
                           input        i-num-processo,
                           input        no,
                           input        table tt-pd-vendor). 
        
       for each tt-erros-geral:
          assign i-seq-erro = i-seq-erro + 1.
          run utp/ut-msgs.p (input "msg",
                             input tt-erros-geral.cod-erro,
                             input "").
          create tt-bo-erro.
          assign tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = tt-erros-geral.cod-erro
                 tt-bo-erro.mensagem     = return-value.
       end.
       find first tt-bo-erro no-error.
       if not avail tt-bo-erro then do:
          find first tt-ped-venda no-error.
          if avail tt-ped-venda then
             buffer-copy tt-ped-venda except ind-tipo-movto to rowObject.
       end.
    end procedure.
    
&ENDIF
