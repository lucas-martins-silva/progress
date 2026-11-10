/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI008 2.00.00.047 } /*** "010047" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi008 MBC}
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
**   Programa: bcapi008 - API que expande a temp-table tt-etiqueta
**
**   Parametros: tt-etiqueta        - Temp-Table com dados a serem fatorados
**               tt-etiqueta-aux    - Temp-Table com dados ja fatorados
**               tt-erro - Apos a execucao da API contera os possiveis
**                         erros de criacao de etiquetas
**
**   Versao de Integracao: 1 - Luciano (07/98)
**
*******************************************************************************/

/* VERSAO DE INTEGRACAO */
&SCOPED-DEFINE Versao-Integracao 1

{method/dbotterr.i}
{cdp/cd0666.i}   /* definicao da temp-table de tt-erros     */
{bcp/bcapi002.i} /* Definicao da temp-table de tt-etiquetas */
{bcp/bcapi011.i} /* Definicao da temp-table de tt-etq-item */
{bcp/bcproxy.i2}    /* Defini‡äes das procedures para integra‡Æo com o Magnus i.00 */

/*** Definicao da temp-table tt-epc ***/
{include/i-epc200.i bcapi008}

def temp-table tt-etiqueta-aux NO-UNDO like tt-etiqueta.
def input-output param table           for tt-etiqueta.
def input-output param table           for tt-etiqueta-aux.
def input-output param table           for tt-erro.
def var i-cont                  as integer             NO-UNDO.
def var i-cont-total            as integer             NO-UNDO.
def var i-seq                   as integer             NO-UNDO.
def var l-erro                  as logical             NO-UNDO.
def var qtd-total-item          as decimal             NO-UNDO.
def var c-nome-abrev            as char format "X(12)" NO-UNDO.


DEFINE BUFFER bf-bc-ext-item FOR bc-ext-item.

for each tt-etiqueta-aux:
    delete tt-etiqueta-aux.
end.

/*** Parametros Coleta de Dados ***/
find first param-bc no-lock no-error.

for each tt-etiqueta transaction:
    /*** Teste da versao de integracao ***/
    if  tt-etiqueta.cod-versao-integracao <> {&Versao-Integracao} then do:
        run utp/ut-msgs.p (input "msg",
                           input 3941,
                           input "").
        create tt-erro.
        assign tt-erro.i-sequen = tt-etiqueta.i-sequen
               tt-erro.cd-erro  = 3941
               tt-erro.mensagem = return-value
               l-erro = yes.
        {utp/ut-liter.i "Multiplica‡Æo das Etiquetas" * L}
        assign tt-erro.mensagem = tt-erro.mensagem + " (" + return-value + ")". 
    end.

    /*** Teste do numero da transacao ***/
    find first bc-trans
         where bc-trans.nr-trans = tt-etiqueta.nr-trans no-lock no-error.
    if  not available(bc-trans) then do:
        {utp/ut-table.i mgcld bc-trans 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input trim(return-value)).
        create tt-erro.
        assign tt-erro.i-sequen = tt-etiqueta.i-sequen
               tt-erro.cd-erro  = 2
               tt-erro.mensagem = return-value
               l-erro = yes.
        {utp/ut-liter.i "Multiplica‡Æo das Etiquetas" * L}
        assign tt-erro.mensagem = tt-erro.mensagem + " (" + return-value + ")".          
    end.

    /*** Testa a transa‡Æo do BC-TRANS ***/
    find first bc-tipo-trans
         where bc-tipo-trans.cd-trans = bc-trans.cd-trans no-lock no-error.
    if  not available(bc-tipo-trans) then do:
        {utp/ut-table.i mgcld bc-tipo-trans 1}
        run utp/ut-msgs.p (input "msg",
                           input 729,
                           input trim(return-value)).
        create tt-erro.
        assign tt-erro.i-sequen = tt-etiqueta.i-sequen
               tt-erro.cd-erro  = 729
               tt-erro.mensagem = return-value
               l-erro = yes.
        {utp/ut-liter.i "Multiplica‡Æo das Etiquetas" * L}
        assign tt-erro.mensagem = tt-erro.mensagem + " (" + return-value + ")". 
    end.

    /*** Testa quantidade do item ***/
    if  tt-etiqueta.quantidade <= 0 then do:
        {utp/ut-table.i mgind item 1}
        run utp/ut-msgs.p (input "msg",
                           input 4570,
                           input trim(return-value)).
        create tt-erro.
        assign tt-erro.i-sequen = tt-etiqueta.i-sequen
               tt-erro.cd-erro  = 4570
               tt-erro.mensagem = return-value
               l-erro = yes.
        {utp/ut-liter.i "Multiplica‡Æo das Etiquetas" * L}
        assign tt-erro.mensagem = tt-erro.mensagem + " (" + return-value + ")". 

    end.

    if  l-erro = yes then undo, next.

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
    /* and ttEmitente.identific <> 2 dako */
    then c-nome-abrev = ttEmitente.nome-abrev.
    else c-nome-abrev = "".

    create  tt-etq-item.
    assign  tt-etq-item.it-codigo               = tt-etiqueta.it-codigo
            tt-etq-item.qt-item                 = tt-etiqueta.quantidade
            tt-etq-item.cod-versao-integracao   = 1
            tt-etq-item.cd-trans                = bc-trans.cd-trans
            tt-etq-item.nome-abrev              = c-nome-abrev
            tt-etiqueta.cd-trans                = bc-trans.cd-trans
            qtd-total-item                      = tt-etiqueta.quantidade.

    run bcp/bcapi011.p (input-output table tt-etq-item). /* fatora o item tt-etiqueta */

    if  return-value = "NOK" then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "ExtensÆo_do_item/familia" *}
        run utp/ut-msgs.p (input "msg",
                           input 56,
                           input RETURN-VALUE).
        create tt-erro.
        assign tt-erro.i-sequen = tt-etiqueta.i-sequen
               tt-erro.cd-erro  = 56
               tt-erro.mensagem = replace(return-value,"."," ").

        {utp/ut-liter.i " ou item nÆo imprime Etiqueta" * L}               
        assign tt-erro.mensagem = tt-erro.mensagem + return-value.

        {utp/ut-liter.i "Multiplica‡Æo das Etiquetas" * L}
        assign tt-erro.mensagem = tt-erro.mensagem + " (" + return-value + ")".       
    end.

    find first tt-etq-item no-lock no-error.

    if (    (tt-etiqueta.qt-etiqueta > 0) 
        and (tt-etiqueta.qt-etiqueta <> tt-etq-item.qt-etiqueta) )
         OR (    (tt-etiqueta.qt-etiqueta > 0) 
        and (tt-etiqueta.qt-item-cli > 0))
    then do:


        /*  o campo qt-item-cli corresponde a quantidade que cada item ter  em cada etiqueta. */
        assign  tt-etq-item.qt-etiqueta     = tt-etiqueta.qt-etiqueta

                tt-etq-item.qt-etiq-item    = (if tt-etiqueta.qt-item-cli <> 0 then tt-etiqueta.qt-item-cli
                                               else
                                                   (if  tt-etiqueta.quantidade >= tt-etiqueta.qt-etiqueta
                                                    then IF  tt-etiqueta.qt-etiqueta = 1
                                                         THEN 
                                                             tt-etiqueta.quantidade 
                                                         ELSE 
                                                             truncate(tt-etiqueta.quantidade / tt-etiqueta.qt-etiqueta,0)
                                                    else IF  tt-etiqueta.qt-etiqueta = 1  /* FO 1350735 */
                                                         THEN 
                                                             tt-etiqueta.quantidade 
                                                         ELSE 1)
                                               )

                tt-etq-item.qt-ult-etiqueta = (IF  tt-etiqueta.qt-etiqueta = 1  
                                               THEN 
                                                    0
                                               ELSE 
                                                    tt-etiqueta.quantidade 
                                                  - ( tt-etq-item.qt-etiq-item *  ( tt-etiqueta.qt-etiqueta - 1 ) )
                                               ).
    end.

    do  i-cont = 1 to tt-etq-item.qt-etiqueta:

        create  tt-etiqueta-aux.
        assign  tt-etiqueta-aux.i-sequen                = i-cont.

        buffer-copy tt-etiqueta 
                    except tt-etiqueta.i-sequen
                    to tt-etiqueta-aux.

        assign  tt-etiqueta-aux.quantidade              = (if   (     i-cont = tt-etq-item.qt-etiqueta
                                                                  and tt-etq-item.qt-ult-etiqueta > 0)
                                                            then tt-etq-item.qt-ult-etiqueta
                                                            else tt-etq-item.qt-etiq-item)

                tt-etiqueta-aux.peso-bruto              =   if  qtd-total-item > 0
                                                            then   (tt-etiqueta-aux.peso-bruto / qtd-total-item)
                                                                 * tt-etiqueta-aux.quantidade
                                                            else 0

                tt-etiqueta-aux.peso-liquido            =   if  qtd-total-item > 0
                                                            then   (tt-etiqueta-aux.peso-liquido / qtd-total-item)
                                                                 * tt-etiqueta-aux.quantidade
                                                            else 0

                tt-etiqueta-aux.nr-embalagem            =   if  tt-etq-item.qt-etiq-item > 0
                                                            then truncate ( (tt-etiqueta-aux.quantidade / tt-etq-item.qt-etiq-item),0)
                                                            else 0

                tt-etiqueta-aux.tipo-etiq               = if tt-etiqueta.tipo-etiq <> 0 then tt-etiqueta.tipo-etiq else tt-etq-item.tipo-etiq
                tt-etiqueta-aux.it-codigo-ext-1         = tt-etq-item.it-codigo-ext-1
                tt-etiqueta-aux.it-codigo-ext-2         = tt-etq-item.it-codigo-ext-2
                tt-etiqueta-aux.it-codigo-ext-3         = tt-etq-item.it-codigo-ext-3
                tt-etiqueta-aux.it-codigo-ext-4         = tt-etq-item.it-codigo-ext-4
                tt-etiqueta-aux.dt-impressao            = IF tt-etiqueta.dt-impressao = ?    THEN TODAY                   ELSE tt-etiqueta.dt-impressao
                tt-etiqueta-aux.hora-Impressao          = IF tt-etiqueta.hora-Impressao = "" THEN string(time,"HH:MM:SS") ELSE tt-etiqueta.hora-Impressao.
                
        /** ROTINA DESCONTINUADA: DMANUFATURA-4592 
        **  Verifica se etiqueta contem RFID 
        **  Campos permenecem no produto devido a liberacao de fontes para cliente LEAL
        **/
        
        IF CAN-FIND(FIRST bf-bc-ext-item
                    WHERE bf-bc-ext-item.it-codigo = tt-etiqueta-aux.it-codigo
                    AND   bf-bc-ext-item.cod-integr-rfid > 0) THEN DO:
              
            find prog_dtsul where prog_dtsul.cod_prog_dtsul = "bcapi008" no-lock no-error.
            if  avail prog_dtsul then do:
                assign c-nom-prog-dpc-mg97  = prog_dtsul.nom_prog_dpc
                       c-nom-prog-appc-mg97 = prog_dtsul.nom_prog_appc
                       c-nom-prog-upc-mg97  = prog_dtsul.nom_prog_upc.
            end.
            
            if  c-nom-prog-dpc-mg97  <> ""  or 
                c-nom-prog-upc-mg97  <> ""  or 
                c-nom-prog-appc-mg97 <> "" then do:
                
                for each tt-epc
                  where tt-epc.cod-event = "gerar-codigo-rfid-epc":
                  delete tt-epc.
                end.
                
                create tt-epc.
                assign tt-epc.cod-event     = "gerar-codigo-rfid-epc"
                       tt-epc.cod-parameter = "tt-etiqueta-handle"
                       tt-epc.val-parameter = STRING(TEMP-TABLE tt-etiqueta-aux:HANDLE).
                
                create tt-epc.
                assign tt-epc.cod-event     = "gerar-codigo-rfid-epc"
                       tt-epc.cod-parameter = "rfid-epc-totvs"
                       tt-epc.val-parameter = string(tt-etiqueta-aux.rfid-epc-totvs).
                
                {include/i-epc201.i "gerar-codigo-rfid-epc"}
                
                FOR EACH tt-epc
                    WHERE tt-epc.cod-event     = "gerar-codigo-rfid-epc":U
                    AND   tt-epc.cod-parameter = "rfid-epc-totvs":U NO-LOCK:
                        
                    ASSIGN tt-etiqueta-aux.rfid-epc-totvs = tt-epc.val-parameter.
                    
                END.
                
            end.
            /** FIM - VALIDACAO DE CADASTRO DE EPC **/
            
        END.
        /**********************************/

        if  ((tt-etiqueta-aux.quantidade / tt-etq-item.qt-etiq-item) - tt-etiqueta-aux.nr-embalagem ) > 0
        then
            assign  tt-etiqueta-aux.nr-embalagem = tt-etiqueta-aux.nr-embalagem + 1.
    end.

    /*****   GERA  ETIQUETA  TOTAL   *****/
    if  bc-tipo-trans.gera-etiq-total
    then do:
        do  i-cont-total = 1 to tt-etq-item.qt-etiqueta-total:
        
            create  tt-etiqueta-aux.
            assign  tt-etiqueta-aux.i-sequen                = i-cont.

            buffer-copy tt-etiqueta 
                        except tt-etiqueta.i-sequen
                        to tt-etiqueta-aux.

            assign  tt-etiqueta-aux.quantidade              = (if   (     i-cont-total = tt-etq-item.qt-etiqueta-total
                                                                      and tt-etq-item.qt-ult-etiq-total > 0)
                                                                then tt-etq-item.qt-ult-etiq-total
                                                                else tt-etq-item.qt-etiq-total)

                    tt-etiqueta-aux.peso-bruto              =   if  qtd-total-item > 0
                                                                then   (tt-etiqueta-aux.peso-bruto / qtd-total-item)
                                                                     * tt-etiqueta-aux.quantidade
                                                                else 0

                    tt-etiqueta-aux.peso-liquido            =   if  qtd-total-item > 0
                                                                then   (tt-etiqueta-aux.peso-liquido / qtd-total-item)
                                                                     * tt-etiqueta-aux.quantidade
                                                                else 0

                    tt-etiqueta-aux.nr-embalagem            =   if  tt-etq-item.qt-etiq-item > 0
                                                                then truncate ( (tt-etiqueta-aux.quantidade / tt-etq-item.qt-etiq-item),0)
                                                                else 0

                    tt-etiqueta-aux.tipo-etiq               = tt-etq-item.tipo-etiq-total
                    tt-etiqueta-aux.it-codigo-ext-1         = tt-etq-item.it-codigo-ext-1
                    tt-etiqueta-aux.it-codigo-ext-2         = tt-etq-item.it-codigo-ext-2
                    tt-etiqueta-aux.it-codigo-ext-3         = tt-etq-item.it-codigo-ext-3
                    tt-etiqueta-aux.it-codigo-ext-4         = tt-etq-item.it-codigo-ext-4
                    tt-etiqueta-aux.dt-impressao            = IF tt-etiqueta.dt-impressao = ?    THEN TODAY                   ELSE tt-etiqueta.dt-impressao
                    tt-etiqueta-aux.hora-Impressao          = IF tt-etiqueta.hora-Impressao = "" THEN string(time,"HH:MM:SS") ELSE tt-etiqueta.hora-Impressao
                    i-cont                                  = i-cont + 1.

            if  ((tt-etiqueta-aux.quantidade / tt-etq-item.qt-etiq-item) - tt-etiqueta-aux.nr-embalagem ) > 0
            then
                assign  tt-etiqueta-aux.nr-embalagem = tt-etiqueta-aux.nr-embalagem + 1.
        end.
    end.
end.


find first tt-erro no-error.
if  available(tt-erro) then
    return "NOK".
else
    return "OK".
    
