/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0124 2.00.00.026 } /*** "010026" 04/11/2026 14:33:19 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i af0124 MAF}
&ENDIF

/*******************************************************************************
**
**   Programa..:  AF0124.P
**   Data......:  Julho de 2001.
**   Objetivo .:  Geracao de pendencias - Contas a Pagar EMS 5  
**                Compilado EMS 2
**
**   Criacao ..:  Xisto Jr.
**
**   i-tipo-docto: 24 - Documento NOrmal
**                 25 - Antecipacao
**                 26 - PEF
**
**   Parümetros passados para lap/mlaapi001.p:
**
**      Tipo de documento        Integer
**      Tipo de transa¯?o        Integer
**      Motivo                   Character
**      Valor                    Decimal
**      Moeda                    Integer
**      Usu˜rio transa¯?o        Character
**      Usu˜rio documento        Character
**      Lota¯?o documento        Character
**      Item                     Character
**      tt-aed-chave             Temp-table
**      tt-erro (output)         Temp-table
**
*******************************************************************************/

{utp/ut-glob.i}
{afp/af0001.i}
{afp/af0124.i}
{cdp/cd0666.i}

/*** Defini‡Æo da tt-log-erros-atualiz ***/
{afp/af0024.i}

define  temp-table tt-erro-aed no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)"
    field c-param  as char.

define  temp-table tt-erro-aed-aux no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)"
    field c-param  as char.

{include/i-epc200.i AF0124}
def new global shared var gi-prox-prior as integer no-undo.
def new global shared var v_cdn_empres_usuar like empresa.ep-codigo no-undo.
def new Global shared var c-seg-usuario as char format "x(12)" no-undo.
DEF NEW GLOBAL SHARED VAR l-del-mla AS LOGICAL NO-UNDO.
DEF VAR v-cod-usuar-docto AS CHARACTER NO-UNDO.
def var c-trad-1          as char      no-undo.
def var c-msg-56          as char      no-undo.
def var c-help-56         as char      no-undo.

DEF INPUT  PARAMETER i-transacao  AS INTEGER NO-UNDO.
DEF INPUT  PARAMETER i-tipo-docto AS INTEGER NO-UNDO.
DEF INPUT  PARAMETER r-documento  AS ROWID   NO-UNDO.
DEF OUTPUT PARAMETER table for tt-erro-aed.

&IF  "{&mginv_version}" >= "2.06B" &THEN

def var v_cod_usuar_aux           as char init "" no-undo.

FOR EACH tt-aed-chave :
    DELETE tt-aed-chave.
END.

FOR EACH tt-aed-chave-aux :
    DELETE tt-aed-chave-aux.
END.

IF  i-transacao = 1
AND (i-tipo-docto = 24 OR i-tipo-docto = 25 OR i-tipo-docto = 26 OR i-tipo-docto = 28) THEN DO:
    FIND FIRST mla-chave-doc-aprov NO-LOCK
        WHERE mla-chave-doc-aprov.cod-tip-doc = i-tipo-docto NO-ERROR.
    IF NOT AVAIL mla-chave-doc-aprov THEN DO:

        {utp/ut-liter.i Chave_do_Documento * r}
        assign c-trad-1 = RETURN-VALUE + " " + STRING(i-tipo-docto).
        run utp/ut-msgs.p (input "msg", input 56, input c-trad-1).
        ASSIGN c-msg-56 = RETURN-VALUE.                   
        run utp/ut-msgs.p (input "help", input 56, input c-trad-1 + "~~" + "MLA0102").
        ASSIGN c-help-56 = RETURN-VALUE.                                   

        CREATE tt-erro-aed.
        ASSIGN tt-erro-aed.i-sequen = 1
               tt-erro-aed.cd-erro  = 56
               tt-erro-aed.mensagem = c-msg-56 + " " + c-help-56
               tt-erro-aed.c-param  = ''.

        RETURN "NOK".
    END.             
END.

if  index(program-name(2), "ecp/ec0001a.w") <> 0 OR index(program-name(4), "ecp/ec0001.w") <> 0 THEN DO:
    RUN pi-tt-aed-chave-aux-cambio.
END.
ELSE DO:
    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF  AVAIL param-global THEN DO:
        RUN prgfin/apf/apf728za.py(INPUT i-tipo-docto,
                                   INPUT r-documento,          
                                   INPUT param-global.ct-format,
                                   INPUT i-transacao,
                                   OUTPUT TABLE tt-aed-chave-aux,
                                   OUTPUT TABLE tt-erro-aed).
        IF  RETURN-VALUE = "nok" THEN
            RETURN "NOK".
    END.
    
    RELEASE param-global.
END.
     
/** Espec Merial, so chama se o programa existir na estrutura */
if search('aedp/aedapb007m.r') <> ? OR search('aedp/aedapb007m.p') <> ? then
    RUN aedp/aedapb007m.p(INPUT r-documento,
                          OUTPUT v_cod_usuar_aux).

/*API de Verifica‡Æo da parametriza‡Æo AED*/
    if  c-seg-usuario = "" then
        assign c-seg-usuario = v_cod_usuar_corren.
    if  not can-find(first funcao
        where funcao.cd-funcao = "valida-doc-espec24") then do:
        create funcao.
        assign funcao.cd-funcao = "valida-doc-espec24"
               funcao.ativo     = yes.
    end.
    if  not can-find(first funcao
        where funcao.cd-funcao = "valida-doc-espec25") then do:
        create funcao.
        assign funcao.cd-funcao = "valida-doc-espec25"
               funcao.ativo     = yes.
    end.
    if  not can-find(first funcao
        where funcao.cd-funcao = "valida-doc-espec26") then do:
        create funcao.
        assign funcao.cd-funcao = "valida-doc-espec26"
               funcao.ativo     = yes.
    end.
    if  not can-find(first funcao
        where funcao.cd-funcao = "valida-doc-espec28") then do:
        create funcao.
        assign funcao.cd-funcao = "valida-doc-espec28"
               funcao.ativo     = yes.
    end.
  
    for each tt-aed-chave-aux:
        run lap/mlaapi173f.p (input i-tipo-docto,                           /*Tipo Documento*/
                              input "",                                     /*Cod. Item*/
                              input if  v_cod_usuar_aux <> "" then
                                        v_cod_usuar_aux
                                    else
                                        tt-aed-chave-aux.valor[8],         /*Usuario Responsavel Documento*/
                              input if  i-tipo-docto <> 25 
                                    AND i-tipo-docto <> 26 then 
                                        string(tt-aed-chave-aux.valor[4]) 
                                    else
                                        string(tt-aed-chave-aux.valor[3]), /*referencia item*/
                              input string(tt-aed-chave-aux.valor[1]),      /*referencia total*/
                              input if  i-tipo-docto <> 25 
                                    AND i-tipo-docto <> 26 then 
                                        string(tt-aed-chave-aux.valor[5]) 
                                    else
                                        string(tt-aed-chave-aux.valor[4]), /*Lotacao Documento*/
                              input DEC(tt-aed-chave-aux.valor[6]),         /*Valor Item*/
                              input DEC(tt-aed-chave-aux.valor[6]),         /*Valor Documento*/
                              input string(tt-aed-chave-aux.valor[1]),      /*Estabelecimento*/
                              input &IF "{&mguni_version}" < "2.07A" &THEN 
                                        int(tt-aed-chave-aux.valor[10]),                 /* Empresa */
                                    &ELSE
                                        tt-aed-chave-aux.valor[10],                     /* Empresa */
                                    &ENDIF
                              output table tt-erro-aed-aux).
       
        if  can-find(first tt-erro-aed-aux) then do:
            for each tt-erro-aed-aux:
                create tt-erro-aed.
                buffer-copy tt-erro-aed-aux to tt-erro-aed.
            end.
       end.
    end.

    if  can-find(first tt-erro-aed) then do:
        FOR EACH tt-erro-aed:
            run utp/ut-msgs(input "help",
                            input tt-erro-aed.cd-erro,
                            input tt-erro-aed.c-param).
            ASSIGN tt-erro-aed.mensagem = tt-erro-aed.mensagem + " " + RETURN-VALUE.
        END.                          
        return "NOK".
    end.

/* Temp-table auxilizar - pode trazer N apropriacoes mas api somente aceita um
   registro por vez */
assign gi-prox-prior = 10.

/*chamada espec­fica para a Merial somente para doc 24 (t¡tulo normal): gera?’o de pendˆncia agrupada por conta cont bil*/
IF i-tipo-docto = 24 THEN
DO:
    IF c-nom-prog-dpc-mg97 <> ''
       OR
       c-nom-prog-appc-mg97 <> ''
       OR
       c-nom-prog-upc-mg97 <> '' THEN
    DO:
        DEF VAR v-hdl AS WIDGET-HANDLE NO-UNDO.
        v-hdl = TEMP-TABLE tt-aed-chave-aux:HANDLE.
        FOR EACH tt-epc.
            DELETE tt-epc.
        END.
    
        CREATE tt-epc.
        assign tt-epc.cod-event     = "PENDENCIA_POR_CTA_CTBL"
               tt-epc.cod-parameter = "Handle_TT"
               tt-epc.val-parameter = string(v-hdl).
        {include/i-epc201.i PENDENCIA_POR_CTA_CTBL}
    END.
END.

run pi_gera_log_temp_table (input buffer tt-aed-chave-aux:handle,
                            input 'AF0124-INPUT').

FOR EACH tt-aed-chave-aux NO-LOCK:
    CREATE tt-aed-chave.
    BUFFER-COPY tt-aed-chave-aux TO tt-aed-chave.
    ASSIGN v-cod-usuar-docto = tt-aed-chave.valor[8].
    CASE i-tipo-docto :
    
        WHEN 24 THEN DO: /* NORMAL */

             run lap/mlaapi001.r (INPUT i-tipo-docto,                          /* Tipo docto */
                                  INPUT i-transacao,                           /* Transacao 1, 2,3 */
                                  INPUT SUBSTRING(tt-aed-chave.valor[9],1,40), /* Motivo Chave Documento EMS 5*/
                                  INPUT DEC(tt-aed-chave.valor[6]),            /* Valor */
                                  INPUT int(tt-aed-chave.valor[7]),            /* moeda(i) */
                                  INPUT v_cod_usuar_corren,                    /* usuario da Transacao */
                                  INPUT if v_cod_usuar_aux <> "" then
                                           v_cod_usuar_aux
                                        else
                                           tt-aed-chave.valor[8],              /* usuario documento */
                                  INPUT tt-aed-chave.valor[5],                 /* (Lotacao) C. custo */
                                  INPUT "",                                    /* Item - branco */
                                  INPUT string(tt-aed-chave.valor[4]),         /* Conta (ct-codigo) - referencia */
                                  INPUT tt-aed-chave.valor[10],                /* Empresa */
                                  INPUT tt-aed-chave.valor[1],                 /* Estabelecimento */ 
                                  input table tt-aed-chave,         
                                  output table tt-erro).  

             run pi_gera_log_temp_table (input buffer tt-erro:handle,
                                         input 'AF0124-OUTPUT').            

               IF c-nom-prog-dpc-mg97 <> ''
                  OR
                  c-nom-prog-appc-mg97 <> ''
                  OR
                  c-nom-prog-upc-mg97 <> '' THEN
               DO:
                   FOR EACH tt-epc 
                      WHERE tt-epc.cod-event = 'PENDENCIA_POR_CTA_CTBL'
                        AND tt-epc.cod-parameter = 'Narrativa':
                       IF NUM-ENTRIES(tt-epc.val-parameter, '/') >=1 THEN
                       DO:
                           IF ENTRY(1, tt-epc.val-parameter, '/') = string(tt-aed-chave.valor[4]) THEN
                           DO:

                               FIND FIRST mla-doc-pend-aprov
                                    WHERE &IF "{&mguni_version}" < "2.07A" &THEN
                                          mla-doc-pend-aprov.ep-codigo = int(tt-aed-chave.valor[10])
                                          &ELSE
                                          mla-doc-pend-aprov.ep-codigo = tt-aed-chave.valor[10]
                                          &ENDIF
                                      AND mla-doc-pend-aprov.cod-estabel = tt-aed-chave.valor[1]
                                      AND mla-doc-pend-aprov.cod-referencia = string(tt-aed-chave.valor[4])
                                      AND mla-doc-pend-aprov.cod-tip-doc = 24
                                      and mla-doc-pend-aprov.ind-situacao = 1
                                      AND mla-doc-pend-aprov.historico = NO
                                      AND mla-doc-pend-aprov.motivo-doc = SUBSTRING(tt-aed-chave.valor[9],1,40) EXCLUSIVE-LOCK NO-ERROR.
                               IF AVAIL mla-doc-pend-aprov THEN
                                   ASSIGN mla-doc-pend-aprov.narrativa-apr = ENTRY(2, tt-epc.val-parameter, '/').
                               
                           END.

                       END.
                   END.
               END.
        END.

        WHEN 25 THEN DO: /* ANTECIPACAO */
            IF  c-nom-prog-upc-mg97  <> "" OR
                c-nom-prog-dpc-mg97  <> "" OR
                c-nom-prog-appc-mg97 <> "" THEN DO:
					
                for each tt-epc
                    where tt-epc.cod-event      = "DOCTO25"
                    and tt-epc.cod-parameter  = "tt-aed-chave.valor":
                    
                    delete tt-epc.
                
                end.
                
                create tt-epc.
                assign tt-epc.cod-event     = "DOCTO25"
                       tt-epc.cod-parameter = "tt-aed-chave.valor"
                       tt-epc.val-parameter = string(i-tipo-docto)           + "-" +
                                              string(i-transacao)            + "-" +
                                              tt-aed-chave.valor[1]  + "-" +
                                              tt-aed-chave.valor[2]  + "-" +
                                              tt-aed-chave.valor[3]  + "-" +
                                              tt-aed-chave.valor[4]  + "-" +
                                              tt-aed-chave.valor[5]  + "-" +
                                              tt-aed-chave.valor[6]  + "-" +
                                              tt-aed-chave.valor[7]  + "-" +
                                              tt-aed-chave.valor[8]  + "-" +
                                              tt-aed-chave.valor[9]  + "-" +
                                              tt-aed-chave.valor[10] + "-".
                
                 
                {include/i-epc201.i DOCTO25}
                                           
                find first tt-epc
                      where tt-epc.cod-event      = "DOCTO25"
                        and tt-epc.cod-parameter  = "RETURN" no-lock no-error.
                
                if  avail tt-epc
                and tt-epc.val-parameter <> "" then do:
                    assign v_cod_usuar_corren    = entry(1,tt-epc.val-parameter,";")
                           tt-aed-chave.valor[8] = entry(2,tt-epc.val-parameter,";").
                end.

			end.

            run lap/mlaapi001.r (INPUT i-tipo-docto,                          /* Tipo docto */
                                 INPUT i-transacao,                           /* Transacao 1, 2,3 */
                                 INPUT SUBSTRING(tt-aed-chave.valor[9],1,40), /* Motivo Chave Documento EMS 5*/
                                 INPUT DEC(tt-aed-chave.valor[6]),            /* Valor */
                                 INPUT int(tt-aed-chave.valor[7]),            /* moeda(i) */
                                 INPUT v_cod_usuar_corren,                    /* usuario da Transacao */
                                 INPUT tt-aed-chave.valor[8],                 /* usuario documento */
                                 INPUT tt-aed-chave.valor[4],                 /* (Lotacao) C. custo */
                                 INPUT "",                                    /* Item - branco */
                                 INPUT string(tt-aed-chave.valor[3]),         /* Conta (ct-codigo) - referencia */
                                 INPUT tt-aed-chave.valor[10],                /* Empresa */
                                 INPUT tt-aed-chave.valor[1],                 /* Estabelecimento */ 
                                 input table tt-aed-chave,         
                                 output table tt-erro).

            run pi_gera_log_temp_table (input buffer tt-erro:handle,
                                        input 'AF0124-OUTPUT').            

        end.

        WHEN 26 THEN DO: /* PEF */

            run lap/mlaapi001.r (INPUT i-tipo-docto,                          /* Tipo docto */
                                  INPUT i-transacao,                           /* Transacao 1, 2,3 */
                                  INPUT SUBSTRING(tt-aed-chave.valor[9],1,40), /* Motivo Chave Documento EMS 5*/
                                  INPUT DEC(tt-aed-chave.valor[6]),            /* Valor */
                                  INPUT int(tt-aed-chave.valor[7]),            /* moeda(i) */
                                  INPUT v_cod_usuar_corren,                    /* usuario da Transacao */
                                  INPUT tt-aed-chave.valor[8],                 /* usuario documento */
                                  INPUT tt-aed-chave.valor[4],                 /* (Lotacao) C. custo */
                                  INPUT "",                                    /* Item - branco */
                                  INPUT string(tt-aed-chave.valor[3]),         /* Conta (ct-codigo) - referencia */
                                  INPUT tt-aed-chave.valor[10],                /* Empresa */
                                  INPUT tt-aed-chave.valor[1],                 /* Estabelecimento */ 
                                  input table tt-aed-chave,         
                                  output table tt-erro).            

            run pi_gera_log_temp_table (input buffer tt-erro:handle,
                                        input 'AF0124-OUTPUT').            
            
        END.

        WHEN 28 THEN DO: /* NORMAL */
            IF  c-nom-prog-upc-mg97  <> "" OR
                    c-nom-prog-dpc-mg97  <> "" OR
                    c-nom-prog-appc-mg97 <> "" THEN DO:

                for each tt-epc
                    where tt-epc.cod-event      = "DOCTO28"
                      and tt-epc.cod-parameter  = "tt-aed-chave.valor":
                    
                    delete tt-epc.
            
                end.
            
                create tt-epc.
                assign tt-epc.cod-event     = "DOCTO28"
                       tt-epc.cod-parameter = "tt-aed-chave.valor"
                       tt-epc.val-parameter = string(i-tipo-docto)           + "-" +
                                              string(i-transacao)            + "-" +
                                              tt-aed-chave.valor[1]  + "-" +
                                              tt-aed-chave.valor[2]  + "-" +
                                              tt-aed-chave.valor[3]  + "-" +
                                              tt-aed-chave.valor[4]  + "-" +
                                              tt-aed-chave.valor[5]  + "-" +
                                              tt-aed-chave.valor[6]  + "-" +
                                              tt-aed-chave.valor[7]  + "-" +
                                              tt-aed-chave.valor[8]  + "-" +
                                              tt-aed-chave.valor[9]  + "-" +
                                              tt-aed-chave.valor[10] + "-".
            
                 
                {include/i-epc201.i DOCTO28}
            
            
                find first tt-epc
                      where tt-epc.cod-event      = "DOCTO28"
                        and tt-epc.cod-parameter  = "RETURN" no-lock no-error.
            
                if  avail tt-epc
                and tt-epc.val-parameter <> "" then do:
                    assign v_cod_usuar_corren    = entry(1,tt-epc.val-parameter,";")
                           tt-aed-chave.valor[8] = entry(2,tt-epc.val-parameter,";").
                end.
                
            end.

            run lap/mlaapi001.r (INPUT i-tipo-docto,                          /* Tipo docto */
                                  INPUT i-transacao,                           /* Transacao 1, 2,3 */
                                  INPUT SUBSTRING(tt-aed-chave.valor[9],1,40), /* Motivo Chave Documento EMS 5*/
                                  INPUT DEC(tt-aed-chave.valor[6]),            /* Valor */
                                  INPUT int(tt-aed-chave.valor[7]),            /* moeda(i) */
                                  INPUT tt-aed-chave.valor[8],                    /* usuario da Transacao */
                                  INPUT tt-aed-chave.valor[8],                 /* usuario documento */
                                  INPUT tt-aed-chave.valor[5],                 /* (Lotacao) C. custo */
                                  INPUT "",                                    /* Item - branco */
                                  INPUT string(tt-aed-chave.valor[4]),         /* Conta (ct-codigo) - referencia */
                                  INPUT tt-aed-chave.valor[10],                /* Empresa */
                                  INPUT tt-aed-chave.valor[1],                 /* Estabelecimento */ 
                                  input table tt-aed-chave,         
                                  output table tt-erro).    

            run pi_gera_log_temp_table (input buffer tt-erro:handle,
                                        input 'AF0124-OUTPUT').            

        end.
    END CASE.
    FOR EACH tt-erro:
        CREATE tt-erro-aed.
        BUFFER-COPY tt-erro TO tt-erro-aed.
    END.
    DELETE tt-aed-chave.
    if  return-value = "NOK" then
        return "NOK".

END.        

FIND FIRST mla-usuar-aprov
	WHERE  mla-usuar-aprov.cod-usuar = v-cod-usuar-docto
	 AND  mla-usuar-aprov.aprova-auto = YES NO-LOCK NO-ERROR.
IF AVAIL mla-usuar-aprov THEN DO:
	find first tt-aed-chave-aux no-error.
	
	FIND FIRST mla-perm-aprov
		 WHERE mla-perm-aprov.ep-codigo   = tt-aed-chave-aux.valor[10]
		   AND mla-perm-aprov.cod-estabel = tt-aed-chave-aux.valor[1]
		   AND mla-perm-aprov.cod-usuar   = v-cod-usuar-docto
		   AND mla-perm-aprov.cod-tip-doc = i-tipo-docto NO-LOCK NO-ERROR.
	IF AVAIL mla-perm-aprov THEN
		run pi-auto-aprovacao.
END.


return "OK".


procedure pi-auto-aprovacao:

    def var cChaveDocAprov as char   no-undo.
    def var iChaveDocAprov as int    no-undo.

    find first tt-aed-chave-aux no-error.

    for each mla-chave-doc-aprov no-lock
        where mla-chave-doc-aprov.cod-tip-doc = i-tipo-docto:

        assign iChaveDocAprov = iChaveDocAprov + 1
               cChaveDocAprov = cChaveDocAprov + tt-aed-chave-aux.valor[iChaveDocAprov] + substring("                    ",1,
                                            (((mla-chave-doc-aprov.posicao-fim - mla-chave-doc-aprov.posicao-ini) + 1) - length(tt-aed-chave-aux.valor[iChaveDocAprov]))).
    end.
    assign cChaveDocAprov = right-trim(cChaveDocAprov).

    find first mla-doc-pend-aprov no-lock
        WHERE &IF "{&mguni_version}" < "2.07A" &THEN
              mla-doc-pend-aprov.ep-codigo   = int(tt-aed-chave-aux.valor[10]) /* Empresa */
              &ELSE
              mla-doc-pend-aprov.ep-codigo   = tt-aed-chave-aux.valor[10] /* Empresa */
              &ENDIF
          and mla-doc-pend-aprov.cod-estabel = tt-aed-chave-aux.valor[1]       /* Estabelecimento */
          and mla-doc-pend-aprov.cod-tip-doc = i-tipo-docto                    /* Tipo de Documento */
          and mla-doc-pend-aprov.chave-doc   = cChaveDocAprov no-error.
    if avail mla-doc-pend-aprov then do:
        find first mla-tipo-doc-aprov no-lock
            where mla-tipo-doc-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo
              and mla-tipo-doc-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
              and mla-tipo-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc no-error.
        if avail mla-tipo-doc-aprov THEN
            run value(mla-tipo-doc-aprov.prog-aprova) (rowid(mla-doc-pend-aprov), v_cod_usuar_corren, no, input-output table tt-log-erros-atualiz).
    end.

    return "ok":U.

end procedure. /* pi-auto-aprovacao */

PROCEDURE pi-tt-aed-chave-aux-cambio:

    find first contrato-imp 
         WHERE ROWID(contrato-imp) = r-documento NO-LOCK NO-ERROR.

    CREATE tt-aed-chave-aux.
    ASSIGN tt-aed-chave-aux.valor[1]  = contrato-imp.cod-estabel
           tt-aed-chave-aux.valor[10]  = String(v_cdn_empres_usuar)
           tt-aed-chave-aux.valor[8]  = c-seg-usuario
		   tt-aed-chave-aux.valor[9]  = 'MEC' + ";" + contrato-imp.referencia + ";" + String(contrato-imp.dt-referencia)
           tt-aed-chave-aux.valor[2] = contrato-imp.referencia
		   tt-aed-chave-aux.valor[3] = contrato-imp.referencia
           tt-aed-chave-aux.valor[6] = String(contrato-imp.vl-contrato)
           tt-aed-chave-aux.valor[7] = String(0)
		   .
	
	if l-del-mla = NO then do:
	define var c-chave-doc as char.
		assign c-chave-doc = 'MEC' + ";" + contrato-imp.referencia + ";" + String(contrato-imp.dt-referencia).
		
		
		FIND FIRST mla-doc-pend-aprov 
            WHERE &IF "{&mguni_version}" < "2.07A" &THEN
				  mla-doc-pend-aprov.ep-codigo   = v_cdn_empres_usuar /* Empresa */
				  &ELSE
				  mla-doc-pend-aprov.ep-codigo   = String(v_cdn_empres_usuar) /* Empresa */
				  &ENDIF
            AND    mla-doc-pend-aprov.cod-estabel = contrato-imp.cod-estabel
            AND    mla-doc-pend-aprov.cod-tip-doc = 25
			and    mla-doc-pend-aprov.cod-referencia = contrato-imp.referencia
			and    mla-doc-pend-aprov.motivo-doc = c-chave-doc NO-LOCK NO-ERROR.
		if avail mla-doc-pend-aprov then do:
			assign i-transacao = 2.
		end.
	end.

END PROCEDURE.

procedure pi_gera_log_temp_table:

    def input param p_hdl_temp_table as handle no-undo.
    def input param p_cod_programa      as char no-undo.

    def var v_hdl_query as handle no-undo.
    def var v_num_cont  as int    no-undo.
    def var v_num_aux_1 as int    no-undo.
    def var v_num_aux_2 as int    no-undo.
    
    if  log-manager:logfile-name <> ?
    and log-manager:logging-level > 2 then do:    
        
        create query v_hdl_query.
        v_hdl_query:set-buffers(p_hdl_temp_table).
        v_hdl_query:query-prepare('for each ' + p_hdl_temp_table:name).
        v_hdl_query:query-open.
        v_hdl_query:get-next.
        
        assign v_num_cont = 1.
        
        do while (not v_hdl_query:query-off-end):
             
             log-manager:write-message('----------------------------------- Registro: ' + string(v_num_cont) + ' -----------------------------------', p_cod_programa).
        
             do v_num_aux_1 = 1 to p_hdl_temp_table:num-fields:
        
                if p_hdl_temp_table:buffer-field(v_num_aux_1):extent > 0 then do:
    
                    do v_num_aux_2 = 1 to p_hdl_temp_table:buffer-field(v_num_aux_1):extent:
                        if p_hdl_temp_table:buffer-field(v_num_aux_1):data-type = 'character' then
                            log-manager:write-message(p_hdl_temp_table:name + "." + p_hdl_temp_table:buffer-field(v_num_aux_1):name + "[" + string(v_num_aux_2) + "]" + " = '" + p_hdl_temp_table:buffer-field(v_num_aux_1):buffer-value(v_num_aux_2) + "'", p_cod_programa).
                        else
                            log-manager:write-message(p_hdl_temp_table:name + "." + p_hdl_temp_table:buffer-field(v_num_aux_1):name + "[" + string(v_num_aux_2) + "]" + " = " + p_hdl_temp_table:buffer-field(v_num_aux_1):buffer-value(v_num_aux_2), p_cod_programa).
                    end.
                end.
                else do:
                    if p_hdl_temp_table:buffer-field(v_num_aux_1):data-type = 'character' then
                        log-manager:write-message(p_hdl_temp_table:name + "." + p_hdl_temp_table:buffer-field(v_num_aux_1):name + " = '" + p_hdl_temp_table:buffer-field(v_num_aux_1):buffer-value() + "'", p_cod_programa).
                    else
                        log-manager:write-message(p_hdl_temp_table:name + "." + p_hdl_temp_table:buffer-field(v_num_aux_1):name + " = " + p_hdl_temp_table:buffer-field(v_num_aux_1):buffer-value(), p_cod_programa).
                end.
             end.
        
             log-manager:write-message('-----------------------------------------------------------------------------------', p_cod_programa).
    
             assign v_num_cont = v_num_cont + 1.
    
             v_hdl_query:get-next.
             
        end.
        
        log-manager:write-message('----------------- Quantidade de Registros da ' + p_hdl_temp_table:name + ': ' + string(v_num_cont - 1) + ' ----------------', p_cod_programa).
        log-manager:write-message('-----------------------------------------------------------------------------------', p_cod_programa).

        v_hdl_query:query-close().
        delete object v_hdl_query.
    
    end.

end procedure.


&endif
