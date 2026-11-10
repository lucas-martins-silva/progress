/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9011E 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9011E MBC}
&ENDIF


/********************

{mip/mi9992.i1 new}
{cdp/cd9000.i}
assign  c-programa    = "bc9011e"
        c-versao      = "I.00"
        c-revisao     = "005".

&IF int(entry(1,PROVERSION,".")) > 7
&THEN
/**********************************************************************************
**     Programa...: bc9011e.p  
**
**     Finalidade.: Adapter da transacao de rquisicao do MagnusI00 
**
**     Criado em..: Setembro 2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
/*{cep/ce0225.i2 "new"}   /* definicao de work-files w-movto w-erro                */*/
{bcp/bc9102.i}          /* Definicao da temp-table de erros do coleta de dados   */
{bcp/bc9107.i}          /* Definicao dos campos de comunicacao com o adapter     */
def NEW shared var c-lote-negativo like movto-estoq.lote       init "" no-undo.

/*********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*********************************************************************************/
Define Variable vEmpresaPrincipal   As Integer              No-undo.
define variable c-conteudo as char no-undo.
define variable i-conteudo as int  no-undo.
/*********************************************************************************/

Do:
    Find First ttIntegracao No-lock No-error.

    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg",
                            input 25346,
                            input "bc9011e").
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 25346
                tt-erro.mensagem = trim(Return-Value).
        Return 'NOK'.
    End.

    c-conteudo = _RetornaValChar('it-codigo').
    Find Item No-lock 
    Where Item.it-codigo = c-conteudo No-error.

    create tt-param.             
    assign tt-param.i-tipo-trans          = 1                                       /* 1-REQ 2-DEV */           
           tt-param.l-considera-reserva   = yes                                     /* Faz Req/Dev com ou sem   
                                                                                       reservas para ordem */   
           tt-param.l-permite-saldo-neg   = no                                      /* Caso o saldo possa ficar 
                                                                                       negativo, esta e a resp. 
                                                                                       do usuario */            
           tt-param.l-permite-dev-sem-req = no                                      /* Permite Dev sem a Req    
                                                                                       correspondente */        
           tt-param.l-atu-reserv-na-dev   = yes                                     /* Atualizar reserva da     
                                                                                       ordem na DEV */          
           tt-param.dt-trans              = today                                   /* Data Transacao */        
           tt-param.serie-docto           = _RetornaValChar('serie-docto')          /* Serie documento */
           tt-param.nro-docto             = _RetornaValInte('nro-docto')            /* Numero documento */     
           tt-param.numero-ordem          = _RetornaValInte('numero-ordem')         /* Numero Ordem Manut */    
           tt-param.item-pai              = ""                                      /* Sempre Branco p/ OM */   
           tt-param.cod-roteiro           = ""                                      /* Sempre Branco p/ OM */   
           tt-param.op-codigo             = _RetornaValInte('op-codigo')            /* Numero da tarefa. Se     
                                                                                       houver apenas uma tarefa 
                                                                                       com reserva para aquele  
                                                                                       item, nao precisa infor- 
                                                                                       mar a tarefa. O programa 
                                                                                       acha a tarefa sozinho */ 
           tt-param.it-codigo             = _RetornaValChar('it-codigo')            /* Codigo do Item */        
           tt-param.cod-refer             = _RetornaValChar('cod-refer')            /* Referencia */            
           tt-param.cod-estabel           = _RetornaValChar('cod-estabel')          /* Estabelecimento */       
           tt-param.cod-depos             = _RetornaValChar('cod-depos')            /* Deposito */              
           tt-param.localizacao           = _RetornaValChar('localizacao')          /* Localizacao */           
           tt-param.lote                  = _RetornaValChar('lote')                 /* Lote */                  
           tt-param.quantidade            = _RetornaValDeci('quantidade')           /* Quantidade */            
           tt-param.un                    = If Avail Item Then Item.un Else ''      /* Un medida Item */        
           tt-param.dt-validade-lote      = _RetornaValData('dt-validade-lote')     /* Se criar um novo saldo,  
                                                                                       para item controlado por 
                                                                                       lote, informar a data de 
                                                                                       validade do lote */      
           tt-param.dt-origem-devolucao   = today.                                  /* Em caso de DEV, informar 
                                                                                       data da REQ referente a  
                                                                                       esta DEV */              

/*     Message 'tt-param.i-tipo-trans          ' tt-param.i-tipo-trans          skip */
/*             'tt-param.l-considera-reserva   ' tt-param.l-considera-reserva   skip */
/*             'tt-param.l-permite-saldo-neg   ' tt-param.l-permite-saldo-neg   skip */
/*             'tt-param.l-permite-dev-sem-req ' tt-param.l-permite-dev-sem-req skip */
/*             'tt-param.l-atu-reserv-na-dev   ' tt-param.l-atu-reserv-na-dev   skip */
/*             'tt-param.dt-trans              ' tt-param.dt-trans              skip */
/*             'tt-param.serie-docto           ' tt-param.serie-docto           skip */
/*             'tt-param.nro-docto             ' tt-param.nro-docto             skip */
/*             'tt-param.numero-ordem          ' tt-param.numero-ordem          skip */
/*             'tt-param.item-pai              ' tt-param.item-pai              skip */
/*             'tt-param.cod-roteiro           ' tt-param.cod-roteiro           skip */
/*             'tt-param.op-codigo             ' tt-param.op-codigo             skip */
/*             'tt-param.it-codigo             ' tt-param.it-codigo             skip */
/*             'tt-param.cod-refer             ' tt-param.cod-refer             skip */
/*             'tt-param.cod-estabel           ' tt-param.cod-estabel           skip */
/*             'tt-param.cod-depos             ' tt-param.cod-depos             skip */
/*             'tt-param.localizacao           ' tt-param.localizacao           skip */
/*             'tt-param.lote                  ' tt-param.lote                  skip */
/*             'tt-param.quantidade            ' tt-param.quantidade            skip */
/*             'tt-param.un                    ' tt-param.un                    skip */
/*             'tt-param.dt-validade-lote      ' tt-param.dt-validade-lote      skip */
/*             'tt-param.dt-origem-devolucao   ' tt-param.dt-origem-devolucao   skip */
/*             View-AS ALERT-BOX INFO BUTTONS OK.                                    */

    run "mip/mi9992.p". 

    for each tt-erro-mi:

        Create  tt-erro.
        Assign  tt-erro.i-sequen = tt-erro-mi.i-sequencia
                tt-erro.cd-erro  = 0
                tt-erro.mensagem = tt-erro-mi.c-descricao.

    end.

    find first tt-erro no-error.

    if avail tt-erro then Return "NOK".                

End. /* Do: Main */

&ENDIF


*************/
