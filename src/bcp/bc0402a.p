/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0402A 2.00.00.013}  /*** "010013" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0402A MBC}
&ENDIF


/*************************************************************************
**
**   Programa: bc0402a.p - Impress∆o de coleta de dados
**
**   Parametros: tt-trans.nr-trans - Nr.Transaá∆o
**               tt-trans.conte£do - Campo RAW com a transaá∆o
**               tt-erro - Apos a execucao da API contera  os  possiveis
**                         erros de criacao de etiquetas
**
**   Versao de Integracao: 1 - Luciano (07/98)
**
**************************************************************************/

/* VERSAO DE INTEGRACAO */
&SCOPED-DEFINE Versao-Integracao 1

{cdp/cd0666.i}                  /* definicao da temp-table de tt-erros */
{bcp/bcapi002.i}                /* Definicao da temp-table de tt-etiquetas */
{include/i-epc200.i bcapi002}   /** Upc **/
{include/i_dbtype.i}
{cdp/cdcfgint.i} /* definiá∆o do pre-processador da release do banco */
/* Variaveis para informaá‰es de tipo-destino da etiqueta */
{bcp/bc0103.i}

define temp-table tt-digita no-undo
    field i-tipo        as inte
    field i-sequen      as inte
    field nr-trans      as deci format "zzzzzzzzz9"
    field cd-trans      as char format "x(8)".

def input        param table for tt-digita.
def input-output param table for tt-erro.

def buffer b-tt-digita for tt-digita.
def temp-table tt-etiqueta-aux NO-UNDO like tt-etiqueta.
def var l-erro          as logical initial no   no-undo.
def var i-aux           as integer initial  1   no-undo.
def var i-etq           as integer              no-undo.
def var i-aux1          as integer              no-undo.
def var i-seq           as integer initial 1    no-undo.
def var c-impressora    as char                 no-undo.
def var c-layout        as char                 no-undo.
def var rw-trans        as raw                  no-undo.
def var c-relacao-arquivos  as character            no-undo.
def var i-arq               as integer              no-undo.

for each tt-digita:
     
    find first bc-trans
         where bc-trans.nr-trans = tt-digita.nr-trans
         exclusive-lock no-wait no-error.

    if  not avail bc-trans
    then do:
        {utp/ut-field.i mgcld bc-trans nr-trans 1}
        run utp/ut-msgs.p (input "msg",
                           input 56,
                           input trim(return-value)).
        create tt-erro.
        assign tt-erro.i-sequen = tt-digita.nr-trans
               tt-erro.cd-erro  = 56
               tt-erro.mensagem = return-value.
        return "NOK".
    end.

    run pi_imprime_por_etiqueta.

    if return-value <> "NOK" then do:

       for each bc-trans-erros 
             of bc-trans exclusive-lock:
           delete bc-trans-erros.
       end.

       assign  bc-trans.estado-trans = 2.

    end.

    if  tt-digita.i-tipo = 2 then leave.

end.

return "OK".

/************************************************************************************************************/
Procedure Pi_Imprime_Por_Etiqueta:


/* tratamento de etiqueta 2d */
/* &IF '{&mgcld_version}' > '2.03' &then */
    
DEF VAR l-etiq-2d AS LOGICAL NO-UNDO.

&IF '{&mgcld_version}' >= '2.04' &THEN

    FOR EACH tt-etiqueta:
        DELETE tt-etiqueta.
    END.
    for each tt-etiqueta-aux.
        delete tt-etiqueta-aux.
    end.
    
    &IF "{&mgcld_dbtype}" = "PROGRESS" &THEN
        assign  rw-trans = bc-trans.conteudo-trans.
    &ELSE
        /**** TRATAMENTO PARA BASES DE DADOS N«O PROGRESS ****/
        run btb/btb928za.p (input bc-trans.conteudo-trans, output rw-trans) no-error.
    
        if (  (    error-status:error
               or  error-status:get-number(1) <> 0)
            and error-status:get-number(1) <> 138
            and error-status:get-number(1) <> 91)
        or  return-value = "NOK"
        then do:
            {utp/ut-field.i mgcld bc-trans conteudo-trans 1}
            run utp/ut-msgs.p ( input "SHOW",
                                input 18895,
                                input return-value + " (RAW)").
    
            return "NOK".
         end.
    &ENDIF
        
    create tt-etiqueta. /* para ter um registro disponivel */
    raw-transfer rw-trans to tt-etiqueta NO-ERROR.
    
    /*TRATATIVA NECESSARIA POR CAUSA DA EVOLU∞ÄO DA TT-ETIQUETA*/
    IF ERROR-STATUS:ERROR
    AND ERROR-STATUS:GET-NUMBER(1) = 4955
    THEN DO:
        RAW-TRANSFER rw-trans to tt-etiqueta_old_v01 NO-ERROR.
        IF ERROR-STATUS:ERROR
        AND ERROR-STATUS:GET-NUMBER(1) = 4955
        THEN DO:
            RAW-TRANSFER rw-trans to tt-etiqueta_old NO-ERROR.
            BUFFER-COPY tt-etiqueta_old TO tt-etiqueta.
        END.
        ELSE DO:
            BUFFER-COPY tt-etiqueta_old_v01 TO tt-etiqueta.
        END.
    END.
    
    assign tt-etiqueta.nr-trans = bc-trans.nr-trans.
    
    IF tt-etiqueta.tipo-etiq <> 0 THEN DO:
        FIND tipo-etiqueta WHERE tipo-etiqueta.tipo-etiq = tt-etiqueta.tipo-etiq NO-LOCK NO-ERROR.
        IF AVAIL tipo-etiqueta THEN
            ASSIGN l-etiq-2d = IF tipo-etiqueta.ind-dimensao = 2 THEN YES
                               ELSE NO.
        ELSE DO:
            {utp/ut-table.i mgcld tipo-etiqueta 1}
            run utp/ut-msgs.p ( input "msg",
                                input 2,
                                input return-value).
            create  tt-erro.
            assign  tt-erro.i-sequen = 1
                    tt-erro.cd-erro  = 2
                    tt-erro.mensagem = TRIM(return-value).
            return "NOK".
        END.
    END.
    ELSE DO:
        run bcp/bcapi008.p (input-output table tt-etiqueta,
                            input-output table tt-etiqueta-aux,
                            input-output table tt-erro).
        
        find first tt-erro no-error.
        if  available(tt-erro) THEN
            return "NOK".
        
        FIND FIRST tt-etiqueta-aux NO-LOCK NO-ERROR.
        IF AVAIL tt-etiqueta-aux THEN DO:
            FIND tipo-etiqueta WHERE tipo-etiqueta.tipo-etiq = tt-etiqueta-aux.tipo-etiq NO-LOCK NO-ERROR.
            IF AVAIL tipo-etiqueta THEN
                ASSIGN l-etiq-2d = IF tipo-etiqueta.ind-dimensao = 2 THEN YES
                                   ELSE NO.
            ELSE DO:
                {utp/ut-table.i mgcld tipo-etiqueta 1}
                run utp/ut-msgs.p ( input "msg",
                                    input 2,
                                    input return-value).
                create  tt-erro.
                assign  tt-erro.i-sequen = 1
                        tt-erro.cd-erro  = 2
                        tt-erro.mensagem = TRIM(return-value).
                return "NOK".
            END.
        END.
        ELSE
            RETURN "NOK".
    END.
&ELSE
    ASSIGN l-etiq-2d = NO.
&ENDIF

IF l-etiq-2d THEN DO:
    FIND bc-tipo-trans
         WHERE bc-tipo-trans.cd-trans = bc-trans.cd-trans
         NO-LOCK NO-ERROR.
    
    &IF "{&mgcld_dbtype}" = "PROGRESS" &THEN   
    if  bc-tipo-trans.prog-etiq <> ""
    THEN
        run value(bc-tipo-trans.prog-etiq)
                 (  input bc-trans.nr-trans,
                    input bc-trans.conteudo-trans,
                    input-output table tt-erro) no-error.
    
    &ELSE
        run btb/btb928za.p (input bc-trans.conteudo-trans, output rw-trans) no-error.

        if (  (    error-status:error
           or  error-status:get-number(1) <> 0)
           and error-status:get-number(1) <> 138
           and error-status:get-number(1) <> 91)
           or  return-value = "NOK"
           then do:
                   {utp/ut-field.i mgcld bc-trans conteudo-trans 1}
                    run utp/ut-msgs.p ( input "SHOW",
                                        input 18895,
                                        input return-value + " (RAW)").
 
                   return "NOK".
           end.
        if  bc-tipo-trans.prog-etiq <> ""
            THEN
                run value(bc-tipo-trans.prog-etiq)
                         (  input bc-trans.nr-trans,
                            input rw-trans,
                            input-output table tt-erro) no-error.
        
    &ENDIF

    /************************************************************/

    find first tt-erro no-error.

    if  not avail tt-erro 
    THEN RETURN "OK".
    ELSE RETURN "NOK".

/* &ELSE */
END.
ELSE DO:

    for each tt-etiqueta.
        delete tt-etiqueta.
    end.
    
    for each tt-etiqueta-aux.
        delete tt-etiqueta-aux.
    end.
    
    &IF "{&mgcld_dbtype}" = "PROGRESS" &THEN
        assign  rw-trans = bc-trans.conteudo-trans.
    &ELSE
        /**** TRATAMENTO PARA BASES DE DADOS N«O PROGRESS ****/
        run btb/btb928za.p (input bc-trans.conteudo-trans, output rw-trans) no-error.
    
        if (  (    error-status:error
               or  error-status:get-number(1) <> 0)
            and error-status:get-number(1) <> 138
            and error-status:get-number(1) <> 91)
        or  return-value = "NOK"
        then do:
            {utp/ut-field.i mgcld bc-trans conteudo-trans 1}
            run utp/ut-msgs.p ( input "SHOW",
                                input 18895,
                                input return-value + " (RAW)").
    
            return "NOK".
         end.
    &ENDIF
    
    create tt-etiqueta. /* para ter um registro disponivel */
    raw-transfer rw-trans to tt-etiqueta NO-ERROR.
    
    /*TRATATIVA NECESSARIA POR CAUSA DA EVOLU∞ÄO DA TT-ETIQUETA*/
    IF ERROR-STATUS:ERROR
    AND ERROR-STATUS:GET-NUMBER(1) = 4955
    THEN DO:
        RAW-TRANSFER rw-trans to tt-etiqueta_old_v01 NO-ERROR.
        IF ERROR-STATUS:ERROR
        AND ERROR-STATUS:GET-NUMBER(1) = 4955
        THEN DO:
            RAW-TRANSFER rw-trans to tt-etiqueta_old NO-ERROR.
            BUFFER-COPY tt-etiqueta_old TO tt-etiqueta.
        END.
        ELSE DO:
            BUFFER-COPY tt-etiqueta_old_v01 TO tt-etiqueta.
        END.
    END.
    
    find first tt-etiqueta no-error.
    assign tt-etiqueta.arquivo  = string(tt-digita.nr-trans) + ".ETQ"
           tt-etiqueta.nr-trans = tt-digita.nr-trans
           tt-etiqueta.cd-trans = tt-digita.cd-trans.
    
    
    /*** Envia tt-etiqueta para ser gerado os tt-etiqueta-aux (fatorado) ***/
    run bcp/bcapi008.p (input-output table tt-etiqueta,
                        input-output table tt-etiqueta-aux,
                        input-output table tt-erro).
    
    find first tt-erro no-error.
    if  available(tt-erro) then
        return "NOK".
    
    /* Validaá∆o do tipo-destino para cada etiqueta ------------------------*/
    /*------------------------------------------------------------------------
       Se destino = Impressora EMS 
          verifica a impressora/layout da etiqueta 
          Se etiqueta.impressora = "" usa a impressora da transaá∆o
       Se destino = msword
          verifica se est† no ambiente windows
    ------------------------------------------------------------------------*/
    
    for each tt-etiqueta-aux break by tt-etiqueta-aux.tipo-etiq:
        if  first-of (tt-etiqueta-aux.tipo-etiq) then do:
            
            find first tipo-etiqueta
                 where tipo-etiqueta.tipo-etiq = tt-etiqueta-aux.tipo-etiq
                 no-lock no-error.
            
            /* A validaá∆o da existencia do tipo-etiqueta ser† feita no bcapi007.p */
            if  not avail tipo-etiqueta then
                next.
    
            /* bc0103.i ----------------------------------------------------*/
            run pi-obtem-campos-impressao (buffer tipo-etiqueta,
                                           output i-tipo-destino,
                                           output c-impres-ems, output c-layout-ems,
                                           output c-doc-msword, output c-imp-windows).
    
            /* Assume destino de geraá∆o da transaá∆o nestes casos ---------*/
            if  i-tipo-destino = 1 /* arquivo */
            or  (i-tipo-destino = 2 /* imp-ems */ and c-impres-ems = "":U) then do:
                find first bc-tipo-trans
                     where bc-tipo-trans.cd-trans = tt-etiqueta-aux.cd-trans
                     no-lock no-error.
                /* validaá∆o da existencia do bc-tipo-trans est† em bcapi007.p */
                if  avail bc-tipo-trans then
                    c-impressora = trim(bc-tipo-trans.char-2).
                else
                    c-impressora = "":U.
                /* verifica se impressora da transaá∆o + layout etiqueta est† ok */
                if  c-impressora <> "":U then do:
                    find first impressora
                         where impressora.nom_impressora = c-impressora
                         no-lock no-error.
                    if  not avail impressora
                    then do:
                        {utp/ut-table.i mguni impressora 1}
                        run utp/ut-msgs.p ( input "msg",
                                            input 2,
                                            input return-value).
                        create  tt-erro.
                        assign  tt-erro.i-sequen = 1
                                tt-erro.cd-erro  = 2
                                tt-erro.mensagem = TRIM(return-value).
                        return "NOK".
                    end.
                    find first layout_impres
                         where layout_impres.nom_impressora     = impressora.nom_impressora
                           and layout_impres.cod_layout_impres  = c-layout-ems
                         no-lock no-error.
                    if  not avail layout_impres
                    then do:
                        run utp/ut-msgs.p ( input "msg":U,
                                            input 25878,
                                            input trim(c-layout-ems) + "~~":U + 
                                                  impressora.nom_impressora + "~~":U +
                                                  tt-etiqueta-aux.cd-trans + "~~":U +
                                                  string(tt-etiqueta-aux.tipo-etiq)).
                        create  tt-erro.
                        assign  tt-erro.i-sequen = 1
                                tt-erro.cd-erro  = 25878
                                tt-erro.mensagem = TRIM(return-value).
                        return "NOK".
                    end.
                end.
                next.
            end.
            /* Verifica ent∆o o destino de geraá∆o da etiqueta ----------------*/
            if  i-tipo-destino = 2 then do: /* impressora-ems */
                find first layout_impres
                     where layout_impres.nom_impressora     = c-impres-ems
                       and layout_impres.cod_layout_impres  = c-layout-ems
                     no-lock no-error.
                if  not avail layout_impres
                then do:
                    run utp/ut-msgs.p ( input "msg",
                                        input 19097,
                                        input trim(c-layout-ems) + "~~" + c-impres-ems).
                    create  tt-erro.
                    assign  tt-erro.i-sequen = 1
                            tt-erro.cd-erro  = 19097
                            tt-erro.mensagem = TRIM(return-value).
                    return "NOK".
                end.
                next.
            end.
            if  i-tipo-destino = 3 then do: /* impress∆o word */
                if  opsys <> "WIN32":U then do:
                    run utp/ut-msgs.p ("msg":U, 25785, string(tt-etiqueta-aux.tipo-etiq) + "~~":U + opsys).
                    create  tt-erro.
                    assign  tt-erro.i-sequen = 1
                            tt-erro.cd-erro  = 25785
                            tt-erro.mensagem = TRIM(return-value).
                    return "NOK".
                end.
                next.
            end.
        end.
    end.
    
    if  tt-digita.i-tipo = 2
    then do:
        for each tt-etiqueta-aux:
            find first b-tt-digita
                 where b-tt-digita.nr-trans   = tt-etiqueta-aux.nr-trans
                   and b-tt-digita.i-sequen   = tt-etiqueta-aux.i-sequen
                 no-lock no-error.
    
            if  not avail b-tt-digita
            then delete tt-etiqueta-aux.
        end.
    end.
    
    find first tt-etiqueta-aux no-lock no-error.
    
    for  each tt-epc
        where tt-epc.cod-event = "Before-Print":
        delete tt-epc.
    end.
    create  tt-epc.
    assign  tt-epc.cod-event     = "Before-Print"
            tt-epc.cod-parameter = "Item"
            tt-epc.val-parameter = tt-etiqueta-aux.it-codigo.
    create  tt-epc.
    assign  tt-epc.cod-event     = "Before-Print"
            tt-epc.cod-parameter = "CodigoTransacao"
            tt-epc.val-parameter = tt-etiqueta-aux.cd-trans.
    create  tt-epc.
    assign  tt-epc.cod-event     = "Before-Print"
            tt-epc.cod-parameter = "NumeroTransacao"
            tt-epc.val-parameter = string(tt-etiqueta-aux.nr-trans).
    create  tt-epc.
    assign  tt-epc.cod-event     = "Before-Print"
            tt-epc.cod-parameter = "TipoEtiqueta"
            tt-epc.val-parameter = string(tt-etiqueta-aux.tipo-etiq).
    
    {include/i-epc201.i "Before-Print"}.
    
    for  each tt-epc
        where tt-epc.cod-event = "Before-Print":
        delete tt-epc.
    end.
    
    /*** Envia tt-etiqueta-aux para impressao ***/
    run bcp/bcapi007.p (input-output table tt-etiqueta-aux,
                        input-output table tt-erro,
                        output c-relacao-arquivos).
    
    find first tt-erro no-error.
    if  available(tt-erro) then
        return "NOK":U.
    
    /* chamada do UPC passando de parametro cada arquivo gerado -----------*/
    
    repeat i-arq = 1 to num-entries(c-relacao-arquivos):
        for  each tt-epc
            where tt-epc.cod-event = "Print":
            delete tt-epc.
        end.
        create tt-epc.
        assign tt-epc.cod-event     = "Print"
               tt-epc.cod-parameter = "file-name"
               tt-epc.val-parameter = entry(i-arq, c-relacao-arquivos).
        {include/i-epc201.i "Print"}.
    end.
    
    for  each tt-epc
        where tt-epc.cod-event = "Print":
        delete tt-epc.
    end.
    
    find first tt-etiqueta-aux no-lock no-error.
    
    for  each tt-epc
        where tt-epc.cod-event = "After-Print":
        delete tt-epc.
    end.
    create  tt-epc.
    assign  tt-epc.cod-event     = "After-Print"
            tt-epc.cod-parameter = "Item"
            tt-epc.val-parameter = tt-etiqueta-aux.it-codigo.
    create  tt-epc.
    assign  tt-epc.cod-event     = "After-Print"
            tt-epc.cod-parameter = "CodigoTransacao"
            tt-epc.val-parameter = tt-etiqueta-aux.cd-trans.
    create  tt-epc.
    assign  tt-epc.cod-event     = "After-Print"
            tt-epc.cod-parameter = "NumeroTransacao"
            tt-epc.val-parameter = string(tt-etiqueta-aux.nr-trans).
    create  tt-epc.
    assign  tt-epc.cod-event     = "After-Print"
            tt-epc.cod-parameter = "TipoEtiqueta"
            tt-epc.val-parameter = string(tt-etiqueta-aux.tipo-etiq).
    
    {include/i-epc201.i "After-Print"}.
    
    for  each tt-epc
        where tt-epc.cod-event = "After-Print":
        delete tt-epc.
    end.
    
    Return "OK".
    
    /* &ENDIF */
END.

END Procedure.



