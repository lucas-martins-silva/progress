&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : bc1001.i
    Purpose     : Procedures para tratamento do destino de saida da etiqueta

    Syntax      : {cdp/cd0666.i} /* definicao tt-erro */
                  {bcp/bc1000.i} /* procedure geraTTErro */
                  {bcp/bc1001.i}

    Description : ContÇm funá‰es para abertura, geraá∆o de dados e fechamento
                  do destino de impress∆o de acordo com tipo-etiqueta

    Author(s)   : Alcides Schulz
    Created     : Janeiro/2001
    Notes       : Pode ser usado pela bcapi007.p
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Variaveis para controle da abertura/fechamento do destino de geraá∆o */
DEFINE STREAM s-etiqueta.
DEF VAR c-saida             AS CHARACTER NO-UNDO.
DEF VAR l-impress-ems       AS LOGICAL   NO-UNDO.
DEF VAR h-imprime           AS HANDLE    NO-UNDO.

/* funá‰es e variaveis para acesso aos parametros de saida da etiqueta */
{bcp/bc0103.i}

/* Variavel para indicar execuá∆o de teste */
DEF NEW GLOBAL SHARED VAR vg-teste-etiqueta     AS LOGICAL   NO-UNDO.
DEF NEW GLOBAL SHARED VAR vg-geracao-word       AS CHARACTER NO-UNDO.
DEF NEW GLOBAL SHARED VAR vg-impres-ems-teste   AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE abreDestinoGeracao Include 
PROCEDURE abreDestinoGeracao :
/*------------------------------------------------------------------------------
  Purpose:     Abre o Destino de Geraá∆o conforme parametros em tipo-etiqueta e
               bc-tipo-trans.
  Parameters:  tipo-etiqueta, cd-trans, arquivo
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-tipo-etiqueta     AS INTEGER   NO-UNDO.
DEF INPUT PARAM p-cd-trans          AS CHARACTER NO-UNDO.
DEF INPUT PARAM p-arquivo           AS CHARACTER NO-UNDO.

    DEF VAR c-impressora            AS CHARACTER NO-UNDO.

    /* reseta vari†veis de controle */
    l-impress-ems = NO.
    
    /* le tipo-etiqueta */
    FIND tipo-etiqueta
        WHERE tipo-etiqueta.tipo-etiq = p-tipo-etiqueta
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL tipo-etiqueta THEN DO:
        {utp/ut-table.i mgcld tipo-etiqueta 1}
        RUN geraTTErro (2, TRIM(RETURN-VALUE), STRING(p-tipo-etiqueta)).
        RETURN "NOK":U.
    END.
    
    /* funá∆o do include bc0103.i */
    RUN pi-obtem-campos-impressao (BUFFER tipo-etiqueta,
                                   OUTPUT i-tipo-destino,
                                   OUTPUT c-impres-ems, OUTPUT c-layout-ems,
                                   OUTPUT c-doc-msword, OUTPUT c-imp-windows).
    
    /* usa o destino de impress∆o da transaá∆o nestes casos */
    if  i-tipo-destino = 1 /* arquivo */
    or  (i-tipo-destino = 2 /* imp-ems */ and c-impres-ems = "":U) then do:
        if  vg-teste-etiqueta then do: /* assume impressora teste */
            c-impressora  = vg-impres-ems-teste.
            l-impress-ems = (if i-tipo-destino = 2 /* imp-ems */ then yes else no).
        end.
        else do: /* usar impressora da transaá∆o */
            find first bc-tipo-trans
                 where bc-tipo-trans.cd-trans = p-cd-trans
                 no-lock no-error.
            if  available(bc-tipo-trans) /* quando Ç teste n∆o est† disponivel */
            and bc-tipo-trans.char-2 <> "":U then do:
                c-impressora = bc-tipo-trans.char-2.
                l-impress-ems = yes.
            end.
        end.

    end.
    else
    /* usa o destino de impress∆o que est† na etiqueta */
    if  i-tipo-destino = 2 then do: /* imp-ems */
        c-impressora = c-impres-ems.
        l-impress-ems = yes.
    end.
    else
    if  i-tipo-destino = 3 then do: /* msword */
        /*etiqueta 2d ainda n∆o trata msword*/
    end.
    
    /* abre rotina de impress∆o do ems */
    if  l-impress-ems then do:
        run btb/btb920za.p persistent set h-imprime (c-impressora, c-layout-ems).
    end.
    /* define nome do arquivo de saida */
    else do:
        if  vg-teste-etiqueta = yes then do:
            c-saida = p-arquivo.
            /* Se o arquivo existe verifica se pode gravar */
            file-info:file-name = c-saida.
            if  file-info:full-pathname <> ?
            and index(file-info:file-type, "W":U) = 0 then do:
                RUN geraTTErro (25768, c-saida, "":U).
                return "NOK":U.
            end.
        end.
        else do: 
            find first param-bc no-lock no-error.
            find first bc-tipo-trans
                 where bc-tipo-trans.cd-trans = p-cd-trans
                 no-lock no-error.
            assign  c-saida =  (if avail param-bc 
                                then param-bc.nome-dir-etiq
                                else "":U)
                    c-saida =   c-saida
                                + ( if  bc-tipo-trans.char-1 <> "":U
                                    then( ( if c-saida <> "":U
                                            then "/":U
                                            else  "":U) 
                                         + trim(bc-tipo-trans.char-1) )
                                    else "":U)
                    c-saida  = (if  opsys = "unix":U then replace(c-saida, "~\":U, "/":U)
                                                     else replace(c-saida, "/":U, "~\":U))
                   /* teste de existencia do diretorio */                
                   file-info:file-name = (if c-saida <> "":U then c-saida else ".":U)
                   /*---------------------------------------------------*/
                   c-saida = c-saida
                           + (if c-saida <> "":U then "/":U else "":U) 
                           + p-arquivo 
                   c-saida = (if opsys = "unix":U then replace(c-saida, "~\":U, "/":U)
                                                  else replace(c-saida, "/":U, "~\":U)).


            /* teste do diretorio */
            if  file-info:pathname = ? then do:
                {utp/ut-liter.i Etiquetas_-_Diret¢rio/Arquivo * L}
                RUN geraTTErro (15891, TRIM(RETURN-VALUE), c-saida).
                return "NOK":U.
            end.

        end.
    end.        
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE abreStream Include 
PROCEDURE abreStream :
/*------------------------------------------------------------------------------
  Purpose:     Abre o stream padr∆o de saida
  Parameters:  l-append
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-append        AS LOGICAL  NO-UNDO.

    /* Para o caso de erro na abertura retorna "NOK" */
    DO  ON ERROR UNDO, LEAVE:
        IF  p-append THEN
            OUTPUT STREAM s-etiqueta TO VALUE(c-saida) APPEND.
        ELSE
            OUTPUT STREAM s-etiqueta TO VALUE(c-saida).
        RETURN "OK":U.
    END.
    RUN geraTTErro (25768, c-saida, "":U).
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE encerraLinha Include 
PROCEDURE encerraLinha :
/*------------------------------------------------------------------------------
  Purpose:     Encerra a linha de impress∆o conforme destino de saida
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Pula linha e fecha arquivo (se for o caso) */
    IF  l-impress-ems THEN
        RUN pi_fnc_impressao_envia_skip in h-imprime (1).
    ELSE DO:
        PUT STREAM s-etiqueta SKIP.
        RUN fechaStream.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviaString Include 
PROCEDURE enviaString :
/*------------------------------------------------------------------------------
  Purpose:     Envia string para destino de geraá∆o aberto previamente
  Parameters:  string
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-string        AS CHARACTER NO-UNDO.

    /* Imprime o campo de acordo com o tipo-destino */
    IF  l-impress-ems THEN
        RUN Pi_Fnc_Impressao_Envia_String_Control IN h-imprime (p-string).
    ELSE
        PUT STREAM s-etiqueta UNFORMATTED p-string.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fechaDestinoGeracao Include 
PROCEDURE fechaDestinoGeracao :
/*------------------------------------------------------------------------------
  Purpose:     Fecha o destino de geraá∆o aberto
  Parameters:  <none>
  Notes:       Ainda n∆o trata funá∆o MSWord
------------------------------------------------------------------------------*/

    IF  l-impress-ems THEN 
        RUN pi_fnc_impressao_fim IN h-imprime.

    IF VALID-HANDLE(h-imprime) THEN 
        DELETE OBJECT h-imprime.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fechaStream Include 
PROCEDURE fechaStream :
/*------------------------------------------------------------------------------
  Purpose:     Fecha o Stream de Sa°da
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OUTPUT STREAM s-etiqueta CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE iniciaLinha Include 
PROCEDURE iniciaLinha :
/*------------------------------------------------------------------------------
  Purpose:     Inicia a impress∆o da linha
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Se est† enviando para arquivo abre/reabre a cada registro */
    IF  l-impress-ems = NO THEN
        RUN abreStream (YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

