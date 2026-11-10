/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI020 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi020 MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1998)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**
**   Programa: bcapi020 - API que expande a temp-table tt-etiqueta
**
**   Parametros: tt-etiqueta        - Temp-Table com dados a serem fatorados
**               tt-erro - Apos a execucao da API contera os possiveis
**                         erros de criacao de etiquetas
**
**   Versao de Integracao: 1 - Luciano (03/2001)
**
*******************************************************************************/

/* VERSAO DE INTEGRACAO */
&SCOPED-DEFINE Versao-Integracao 1

{cdp/cd0666.i}   /* definicao da temp-table de tt-erros     */
{bcp/bcapi002.i} /* Definicao da temp-table de tt-etiquetas */
{bcp/bcapi011.i} /* Definicao da temp-table de tt-etq-item */
{bcp/bcproxy.i2}    /* Definiá‰es das procedures para integraá∆o com o Magnus i.00 */

def temp-table tt-etiqueta-aux no-undo like tt-etiqueta.

def input        param table    for tt-etiqueta.
def input-output param table    for tt-erro.

def var qtd-total-item          as decimal.
def var c-nome-abrev            as char format "X(12)".
def var c-relacao-arquivos      as character            no-undo.
def var c-saida                 as character            no-undo.

assign  c-saida = string(time) + ".etq".

/*** Parametros Coleta de Dados ***/
find first param-bc no-lock no-error.

for each tt-etiqueta
    by tt-etiqueta.i-sequen:

    for each tt-etq-item:
        delete tt-etq-item.
    end.

    run pi-verifica-emitente ( input "",                            /* Nome Abreviado inicial       */
                               input "",                            /* Nome Abreviado Final         */
                               input tt-etiqueta.cod-emitente,      /* Codigo do Emitente           */
                               input tt-etiqueta.cod-emitente,      /* Codigo do Emitente           */
                               input 0,    /* Tipo de Acesso 0=Currente ....   */
                               input 2).   /* Record-Frase = 2 (nome abreviado)*/

    if  not avail ttReturnMessages
    and ttEmitente.identific <> 2
    then c-nome-abrev = ttEmitente.nome-abrev.
    else c-nome-abrev = "".


    if  tt-etiqueta.it-codigo <> ""
    then do:
        create  tt-etq-item.
        assign  tt-etq-item.it-codigo               = tt-etiqueta.it-codigo
                tt-etq-item.qt-item                 = tt-etiqueta.quantidade
                tt-etq-item.cod-versao-integracao   = 1
                tt-etq-item.cd-trans                = tt-etiqueta.cd-trans
                tt-etq-item.nome-abrev              = c-nome-abrev
                qtd-total-item                      = tt-etiqueta.quantidade.

        run bcp/bcapi011.p (input-output table tt-etq-item). /* fatora o item tt-etiqueta */

        if  return-value = "NOK" then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Extená∆o_do_item/familia" *}
            run utp/ut-msgs.p (input "msg",
                               input 56,
                               input RETURN-VALUE).
            create tt-erro.
            assign tt-erro.i-sequen = tt-etiqueta.i-sequen
                   tt-erro.cd-erro  = 56
                   tt-erro.mensagem = replace(return-value,"."," ").
            
            {utp/ut-liter.i " ou item n∆o imprime Etiqueta" * L}               
            assign tt-erro.mensagem = tt-erro.mensagem + return-value.
             
            {utp/ut-liter.i "Multiplicaá∆o das Etiquetas" * L}
            assign tt-erro.mensagem = tt-erro.mensagem + " (" + return-value + ")".       
        end.

        find first tt-etq-item no-lock no-error.

        assign  tt-etiqueta.tipo-etiq               = if tt-etiqueta.tipo-etiq <> 0 then tt-etiqueta.tipo-etiq else tt-etq-item.tipo-etiq
                tt-etiqueta.it-codigo-ext-1         = tt-etq-item.it-codigo-ext-1
                tt-etiqueta.it-codigo-ext-2         = tt-etq-item.it-codigo-ext-2
                tt-etiqueta.it-codigo-ext-3         = tt-etq-item.it-codigo-ext-3
                tt-etiqueta.it-codigo-ext-4         = tt-etq-item.it-codigo-ext-4
                tt-etiqueta.dt-impressao            = today
                tt-etiqueta.hora-Impressao          = string(time,"HH:MM:SS")
                tt-etiqueta.qt-etiqueta             = if tt-etiqueta.qt-etiqueta <> 0 then tt-etiqueta.qt-etiqueta else 1.

    end.
    else do:
        find first bc-tipo-trans
             where bc-tipo-trans.cd-trans = tt-etiqueta.cd-trans
             no-lock no-error.
        if  avail bc-tipo-trans
        then 
            assign  tt-etiqueta.tipo-etiq = bc-tipo-trans.tipo-etiq.

        if  tt-etiqueta.tipo-etiq = 0
        then 
            assign  tt-etiqueta.tipo-etiq = param-bc.tipo-etiq.
    end.

    assign  tt-etiqueta.arquivo = if tt-etiqueta.arquivo <> "" then tt-etiqueta.arquivo else c-saida.
    
    for each tt-etiqueta-aux:
        delete tt-etiqueta-aux.
    end.
    
    create tt-etiqueta-aux.
    buffer-copy tt-etiqueta to tt-etiqueta-aux no-error.
    
    /*** Envia tt-etiqueta-aux para impressao ***/
    run bcp/bcapi007.p (input-output table tt-etiqueta-aux,
                        input-output table tt-erro,
                        output c-relacao-arquivos).                        
    
end.

find first tt-erro no-error.
if  available(tt-erro) then
    return "NOK".
else
    return "OK".
