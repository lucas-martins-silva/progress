&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI019 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPI019 MUT}
&ENDIF


/*------------------------------------------------------------------------
    File        : BCAPI019
    Purpose     : Decodificaá∆o da String 2D

    Syntax      : run bcp/bcapi019.p (nome-abrev, string, tt-campos, tt-erro)

    Description : Extrai os dados da string 2D (lida pelo scanner 2D) de
                  acordo com o layout de registro definido para a etiqueta.
                  Retorna na temp-table tt-campos os dados extraidos e o 
                  num-versao do layout que foi usado.

    Author(s)   : Alcides Schulz
    Created     : Janeiro/2001
    Notes       : Em caso de erro retorna "NOK" e erros em tt-erro.
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{bcp/bcapi019.i}                    /* temp-table tt-campos */
{cdp/cd0666.i}                      /* temp-table tt-erros */
{bcp/bc1000.i &local=BCAPI019}      /* procedure geraTTErro */
{bcp/bc1003.i}                      /* funá∆o formataCodLayout */
{utp/ut-glob.i}
{cdp/cdcfgint.i}                    /* versao do produto */

DEF INPUT PARAM p-nome-abrev        AS character NO-UNDO.
DEF INPUT PARAM p-transacao         AS CHARACTER NO-UNDO.
DEF INPUT PARAM p-string2d          AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-campos.    
DEF OUTPUT PARAM TABLE FOR tt-erro.
DEF OUTPUT PARAM p-num-versao       AS INTEGER   NO-UNDO.

/* EPC para 2D-Input */
{include/i-epc200.i bcapi019}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* identifica o layout da etiqueta do emitente */
RUN obtemLayout (INPUT p-nome-abrev, INPUT p-transacao,BUFFER bc-layout).
IF  RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U. /*  erros est∆o em tt-erro */

/* decodifica a string conforme o layout e grava os campos em tt-campos */
RUN decodificaString (p-string2d, BUFFER bc-layout).
IF  RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U. /* erros est∆o em tt-erro */

/* retorna a vers∆o do layout que foi usado */
p-num-versao = bc-layout.num-versao.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-CarregaCampoFixo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CarregaCampoFixo Procedure 
PROCEDURE CarregaCampoFixo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF PARAM BUFFER pbc-layout-registro       FOR bc-layout-registro.
DEF INPUT PARAM  v-registro                AS INT  NO-UNDO.
DEF VAR C-VALOR                            AS CHAR NO-UNDO.
DEF VAR c-valor-campo                      AS CHAR NO-UNDO.

/* Gerar os campos com valores prÇ-fixados, campos fixos */

FIND FIRST PARAM-BC NO-LOCK NO-ERROR.

FOR EACH  bc-layout-registro-item NO-LOCK
    WHERE bc-layout-registro-item.num-layout-registro = pbc-layout-registro.num-layout-registro
    AND   bc-layout-registro-item.tipo-item = 6: /* campo fixo */

    /* grava em tt-campos o campo localizado e seu valor */
    
    &IF  '{&mgcld_version}' > '2.04' 
    &THEN
    ASSIGN c-valor-campo = bc-layout-registro-item.valor-campo.
    &ELSE
    ASSIGN c-valor-campo = bc-layout-registro-item.char-2.
    &ENDIF
    
    IF  c-valor-campo = ? THEN NEXT.

    ASSIGN C-VALOR = c-valor-campo.
    
    IF  INDEX(c-valor-campo,"FNC-TODAY":U) > 0 THEN DO: 
    
        IF  INDEX(bc-layout-registro-item.FORMATO,"D":U) > 0  
        OR  INDEX(bc-layout-registro-item.FORMATO,"M":U) > 0  
        OR  INDEX(bc-layout-registro-item.FORMATO,"A":U) > 0  
        OR  INDEX(bc-layout-registro-item.FORMATO,"Y":U) > 0  
        THEN  DO:

            ASSIGN 
                   C-valor = REPLACE(C-valor,"YY":U,"AA":U).
               
            IF  index(C-valor,"DD":U) <> 0 
            THEN
                ASSIGN SUBSTRING(c-valor,index(C-valor,"DD":U)) = STRING(DAY(TODAY),"99":U).
    
            IF  index(C-valor,"MM":U) <> 0 
            THEN
                ASSIGN SUBSTRING(c-valor,index(C-valor,"MM":U)) = STRING(MONTH(TODAY),"99":U).
    
            IF  index(C-valor,"AAAA":U) <> 0 
            THEN
                ASSIGN SUBSTRING(c-valor,index(C-valor,"AAAA":U)) = STRING(YEAR(TODAY),"9999":U).
            ELSE 
                IF  index(C-valor,"AA":U) <> 0 
                THEN
                    ASSIGN SUBSTRING(c-valor,index(C-valor,"AA":U)) = SUBSTRING(STRING(YEAR(TODAY),"9999":U),3,2).
        END.
        ELSE 
            ASSIGN c-valor = STRING(TODAY,bc-layout-registro-item.FORMATO). 
    END.
    
    IF c-valor-campo = "FNC-TIME":U 
    THEN
        ASSIGN C-VALOR = string(STRING(TIME,"hh:mm:ss":U),bc-layout-registro-item.FORMATO).

    IF c-valor-campo = "FNC-NUMBER-RECORD":U 
    THEN
        ASSIGN C-VALOR = string(STRING(v-registro),bc-layout-registro-item.FORMATO).

    
    IF  c-valor-campo = "FNC-USER":U 
    THEN              
         ASSIGN C-VALOR = IF  
                &if '{&mgcld_version}' <= '2.04' &then
                PARAM-BC.INT-2 &else PARAM-BC.INd-sistema &endif
                = 1 THEN STRING(C-SEG-USUARIO,bc-layout-registro-item.FORMATO)
                         ELSE string(USERID("MGADM":U),bc-layout-registro-item.FORMATO).
    
    IF  c-valor-campo = "FNC-COMPANY":U 
    THEN
        ASSIGN C-VALOR = STRING(i-ep-codigo-usuario,bc-layout-registro-item.FORMATO).
    
    IF  C-VALOR = ? THEN NEXT.

    RUN criaTTCampos (pbc-layout-registro.sequencia,  
                      pbc-layout-registro.num-layout-registro,
                      v-registro, 
                      BUFFER bc-layout-registro-item, 
                      C-VALOR).

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-criaTTCampos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTCampos Procedure 
PROCEDURE criaTTCampos :
/*------------------------------------------------------------------------------
  Purpose:     Cria tt-campos com o conteudo lido e define nome-campo
  Parameters:  sequencia, segmento, registro, bc-layout-registro-item, conteudo
  Notes:       Somente cria tt-campo para campo, campo fixo e auxiliar
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-sequencia                 AS INTEGER   NO-UNDO.
DEF INPUT PARAM p-segmento                  AS INTEGER   NO-UNDO.
DEF INPUT PARAM p-registro                  AS INTEGER   NO-UNDO.
DEF PARAM BUFFER pb-layout-registro-item    FOR bc-layout-registro-item.
DEF INPUT PARAM p-conteudo                  AS CHARACTER NO-UNDO.

DEF VAR v-nome-campo        AS CHARACTER NO-UNDO.
DEF VAR c-formato           AS CHAR      NO-UNDO.
DEF VAR dt-data             AS DATE      NO-UNDO.
DEF VAR i-dia               AS INT       NO-UNDO.
DEF VAR i-mes               AS INT       NO-UNDO.
DEF VAR i-ano               AS INT       NO-UNDO.
DEF VAR v-decimal-aux       AS DECIMAL DECIMALS 10 NO-UNDO.
DEF VAR l-logical           AS LOGICAL   NO-UNDO.

/* define nome do campo de acordo com o tipo-item */
CASE pb-layout-registro-item.tipo-item:
    WHEN 1 /* Campo */ OR
    WHEN 5 /* Auxiliar */ OR
    WHEN 6 /* Campo Fixo */ THEN
        v-nome-campo = pb-layout-registro-item.valor-item.
    WHEN 2 /* Constante */ OR 
    WHEN 3 /* Nova Linha */ OR
    WHEN 4 /* Espacos */ THEN
        RETURN.
END CASE.

/*** trata campos do tipo DATE  ****/
IF  pb-layout-registro-item.tipo-dado = "DATE":U 
AND (   pb-layout-registro-item.tipo-item = 1  /* campo    */ 
     or pb-layout-registro-item.tipo-item = 5) /* auxiliar */
THEN DO:
     
    IF index(pb-layout-registro-item.formato,"D":U) > 0
    OR index(pb-layout-registro-item.formato,"M":U) > 0
    OR index(pb-layout-registro-item.formato,"Y":U) > 0
    OR index(pb-layout-registro-item.formato,"A":U) > 0
    THEN DO:
        
        ASSIGN c-formato = REPLACE(pb-layout-registro-item.formato,"Y":U,"A":U).
    
        ASSIGN i-dia = int(SUBSTRING(p-conteudo,INDEX(c-formato,"DD":U),2)) NO-ERROR. 
        ASSIGN i-mes = int(SUBSTRING(p-conteudo,INDEX(c-formato,"MM":U),2)) NO-ERROR.
        
        IF INDEX(c-formato,"AAAA":U) > 0 
        THEN
            ASSIGN i-ano = int(SUBSTRING(p-conteudo,INDEX(c-formato,"AAAA":U),4) ) NO-ERROR.
        ELSE
            IF INDEX(c-formato,"AA":U)  > 0    
            THEN
                ASSIGN i-ano = int(SUBSTRING(p-conteudo,INDEX(c-formato,"AA":U),2)) NO-ERROR.
    
        ASSIGN dt-data = DATE(i-mes,i-dia,i-ano) NO-ERROR.
    
        ASSIGN p-conteudo = (IF dt-data = ? THEN p-conteudo ELSE string(dt-data,"99/99/9999":U)). 
    
    END.

END.

/*** trata campos do tipo LOGICAL ****/

IF  pb-layout-registro-item.tipo-dado = "LOGICAL":U 
AND (   pb-layout-registro-item.tipo-item = 1  /* campo    */ 
     or pb-layout-registro-item.tipo-item = 5) /* auxiliar */
THEN DO:

    ASSIGN l-logical = IF p-conteudo = "yes":U
                       OR p-conteudo = "sim":U 
                       OR p-conteudo = "si":U
                       OR p-conteudo = "1":U
                       THEN YES
                       ELSE
                       IF p-conteudo = "no":U
                       OR p-conteudo = "n∆o":U
                       OR p-conteudo = "nao":U
                       OR p-conteudo = "0":U   
                       THEN NO
                       ELSE NO
                       NO-ERROR.           
    
    ASSIGN p-conteudo = (IF l-logical = ? THEN p-conteudo ELSE STRING(l-logical)). 

END.

/*** trata campos do tipo DECIMAL ****/

IF  pb-layout-registro-item.tipo-dado = "DECIMAL":U 
AND (   pb-layout-registro-item.tipo-item = 1  /* campo    */ 
     or pb-layout-registro-item.tipo-item = 5) /* auxiliar */
THEN DO:
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    
    ASSIGN v-decimal-aux = DEC(p-conteudo) NO-ERROR.
    
    IF  ERROR-STATUS:ERROR = NO
    THEN DO:

        ASSIGN v-decimal-aux = v-decimal-aux / EXP(10,pb-layout-registro-item.num-decimais) NO-ERROR.

        ASSIGN p-conteudo = (IF v-decimal-aux = ? THEN p-conteudo ELSE STRING(v-decimal-aux)).
      
    END.
    
END.

/* cria registro tt-campos */    
CREATE tt-campos.
ASSIGN tt-campos.sequencia   = p-sequencia
       tt-campos.segmento    = p-segmento
       tt-campos.registro    = p-registro
       tt-campos.campo       = v-nome-campo
       tt-campos.valor       = p-conteudo
       tt-campos.num-decimal = pb-layout-registro-item.num-decimais.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decodificaString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE decodificaString Procedure 
PROCEDURE decodificaString :
/*------------------------------------------------------------------------------
  Purpose:     Extrai as informaá‰es da String 2D e grava em tt-campos
  Parameters:  string2d, cod-layout, log-datasul, num-versao
  Notes:       Grava dados em tt-campos
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-string        AS CHARACTER NO-UNDO.
DEF PARAM BUFFER pb-layout      FOR bc-layout.

DEF VAR c-indicador-ini            AS CHARACTER NO-UNDO.
DEF VAR c-indicador-fim            AS CHARACTER NO-UNDO.

   
/* processa cada segmento de registros do layout */
FOR EACH bc-layout-registro NO-LOCK
    WHERE bc-layout-registro.cod-layout  = pb-layout.cod-layout
      AND bc-layout-registro.log-datasul = pb-layout.log-datasul
      AND bc-layout-registro.num-versao  = pb-layout.num-versao:
      
    &IF  '{&mgcld_version}' > '2.04' 
    &THEN
    ASSIGN c-indicador-ini = bc-layout-registro.indicador-ini
           c-indicador-fim = bc-layout-registro.indicador-fim.
     
    &ELSE
    ASSIGN c-indicador-ini = bc-layout-registro.char-1
           c-indicador-fim = bc-layout-registro.char-2.
    &ENDIF

    CASE pb-layout.ind-leitura-campo:
        WHEN 2 THEN /* tamanho fixo */
            RUN decodificaStringTamanhoFixo (BUFFER bc-layout-registro, 
                                             INPUT-OUTPUT p-string, 
                                             c-indicador-ini,
                                             c-indicador-fim).
                                             
        
        WHEN 3 THEN /* separador */
            RUN decodificaStringSeparador (BUFFER bc-layout-registro, INPUT-OUTPUT p-string, 
                                           pb-layout.separador-campos,                                            
                                           &IF  '{&mgcld_version}' > '2.04' 
                                           &THEN
                                           pb-layout.separador-linhas,
                                           c-indicador-ini,
                                           c-indicador-fim).
                                           &ELSE
                                           pb-layout.cod-aux[1],
                                           c-indicador-ini,
                                           c-indicador-fim).
                                           &ENDIF
        
        WHEN 4 THEN /* identificador */
            RUN decodificaStringIdentificador (BUFFER bc-layout-registro, 
                                               INPUT-OUTPUT p-string, 
                                               NO,
                                               c-indicador-ini,
                                               c-indicador-fim).
                                               
        WHEN 5 THEN /* AIM Brasil */
            RUN decodificaStringIdentificador (BUFFER bc-layout-registro, 
                                               INPUT-OUTPUT p-string,
                                               YES,
                                               c-indicador-ini,
                                               c-indicador-fim).
    END CASE.
    
    /* se aconteceu algum erro nas procedures retorna "NOK" */
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
  
END.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decodificaStringIdentificador) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE decodificaStringIdentificador Procedure 
PROCEDURE decodificaStringIdentificador :
/*------------------------------------------------------------------------------
  Purpose:     Extrair informaá‰es usando idenficadores de campo e padr∆o AIM Brasil
  Parameters:  desc-segmento, bc-layout-registro, string, padrao-aim?
  Notes:       retorna NOK em caso de erro
------------------------------------------------------------------------------*/

DEF PARAM BUFFER pb-layout-registro     FOR bc-layout-registro.
DEF INPUT-OUTPUT PARAM p-string         AS CHARACTER NO-UNDO.
DEF INPUT PARAM p-padrao-aim            AS LOGICAL   NO-UNDO.
DEF INPUT PARAM p-id-seg-ini            AS CHARACTER NO-UNDO.
DEF INPUT PARAM p-id-seg-fim            AS CHARACTER NO-UNDO.

DEF VAR v-primeiro-campo                AS LOGICAL   NO-UNDO.
DEF VAR v-pos-id-final                  AS INTEGER   NO-UNDO.
DEF VAR v-conteudo                      AS CHARACTER NO-UNDO.
DEF VAR v-registro                      AS INTEGER   NO-UNDO.


bloco-leitura-campos:
REPEAT: /* este repeat Ç controlado por bc-layout.ind-ocorrencia */
    
    v-primeiro-campo = YES.
    v-registro = v-registro + 1.

    /* obtem cada campo do segmento de registro */
    FOR EACH bc-layout-registro-item NO-LOCK
        WHERE bc-layout-registro-item.num-layout-registro = pb-layout-registro.num-layout-registro
        AND   bc-layout-registro-item.tipo-item <> 6 /* campo fixo */:
    
        /* tratamento de nova linha */
        IF  bc-layout-registro-item.tipo-item = 3 /* nova linha */ THEN DO:
            RUN decodificaStringNovaLinha (bc-layout-registro-item.valor-item, 
                                           INPUT-OUTPUT p-string,
                                           pb-layout-registro.sequencia,
                                           pb-layout-registro.num-layout-registro,
                                           v-registro).
            IF  RETURN-VALUE = "OK":U THEN
                NEXT.
            IF  RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
        END.

        /* verifica se foi informado ID Inicial e Final (nova linha n∆o precisa de ID) */
        IF  bc-layout-registro-item.id-inicial = "":U THEN DO:
            {utp/ut-liter.i "Inicial"}
            RUN geraErroID (TRIM(RETURN-VALUE), BUFFER bc-layout-registro-item, BUFFER pb-layout-registro).
            RETURN "NOK":U.
        END.
        
        IF  bc-layout-registro-item.id-final = "":U THEN DO:
            {utp/ut-liter.i "Final"}
            RUN geraErroID (TRIM(RETURN-VALUE), BUFFER bc-layout-registro-item, BUFFER pb-layout-registro).
            RETURN "NOK":U.
        END.

        /* trata tipo-item: Campo, Constante, Auxiliar, campo fixo */
        /* verifica se a string comeáa pelo id-inicial */
        IF  NOT p-string BEGINS bc-layout-registro-item.id-inicial THEN DO:               
                
            /* trata identificador inicial de segmento */
            IF  p-string BEGINS p-id-seg-ini 
            AND p-id-seg-ini  <> ""
            THEN DO:
            
                ASSIGN 
                      p-string = SUBSTR(p-string, INDEX(p-string, p-id-seg-ini) + LENGTH(p-id-seg-ini)).

                IF  p-padrao-aim 
                THEN
                    ASSIGN 
                          p-string = SUBSTR(p-string, INDEX(p-string, "@") + 1).                    
            END.
            
            /* trata identificador final de seguimento */
            IF  p-string BEGINS p-id-seg-fim 
            AND p-id-seg-fim  <> "":U
            THEN DO:
                ASSIGN 
                       p-string = SUBSTR(p-string, INDEX(p-string, p-id-seg-fim  
                                                         + (IF p-padrao-aim THEN "@":U ELSE "":U))  
                                                         + LENGTH(p-id-seg-fim  
                                                                  + (IF p-padrao-aim THEN "@":U ELSE "":U))).
                IF  p-padrao-aim 
                THEN 
                    ASSIGN 
                         p-string = SUBSTR(p-string, INDEX(p-string, "@") + 1).                

                LEAVE bloco-leitura-campos.
            END.
           
            /* ap¢s verificar os identificadores verifica novamente id do campo */
            IF  NOT p-string BEGINS bc-layout-registro-item.id-inicial THEN DO:

                /* se for o primeiro campo e layout tiver n ocorrencias considera 
                    que Ç inicio de outro segmento de registros */
                IF  v-primeiro-campo = YES
                AND pb-layout-registro.ind-ocorrencia = 2 THEN
                    LEAVE bloco-leitura-campos.

                /* erro n∆o encontrou id-inicial do campo */
                {utp/ut-liter.i "Inicial":U}
                RUN geraTTErro (25946, TRIM(RETURN-VALUE) + "~~":U + bc-layout-registro-item.valor-item, "":U).
                RETURN "NOK":U.
            END.

        END.

        /* retira id-inicial da string */
        p-string = SUBSTR(p-string, LENGTH(bc-layout-registro-item.id-inicial) + 1).
        
        /* localiza inicio do id-final. no caso de Padr∆o AIM sempre Ç @ */
        v-pos-id-final = INDEX(p-string, bc-layout-registro-item.id-final).
        
        /* se Ç padr∆o AIM verifica se n∆o Ç "@@" (arroba no valor do campo) */
        IF  p-padrao-aim THEN DO:
            REPEAT WHILE v-pos-id-final <> 0:
                /* se tiver 2 @Ôs juntos, procura o pr¢ximo @ a partir desta posiá∆o */
                IF  SUBSTR(p-string, v-pos-id-final + 1, 1) = "@":U THEN
                    v-pos-id-final = INDEX(p-string, "@":U, v-pos-id-final + 2).
                ELSE
                    LEAVE.
            END.
        END.
        
        /* verifica se achou id-final. Constante e espaáo n∆o precisam de id-final */
        IF  v-pos-id-final = 0 THEN DO:
            IF  bc-layout-registro-item.tipo-item = 2 /* constante */ THEN
                v-pos-id-final = LENGTH(bc-layout-registro-item.valor-item) + 1.
            ELSE
            IF  bc-layout-registro-item.tipo-item = 4 /* espaáo */ THEN
                v-pos-id-final = MAX(1, INTEGER(bc-layout-registro-item.valor-item)) + 1 NO-ERROR.
            ELSE DO:
                {utp/ut-liter.i "Final":U}
                RUN geraTTErro (25946, TRIM(RETURN-VALUE) + "~~":U + bc-layout-registro-item.valor-item, "":U).
                RETURN "NOK":U.
            END.
        END.
        
        /* extrai o valor do campo atÇ a posiá∆o do id-final */
        v-conteudo = SUBSTR(p-string, 1, v-pos-id-final - 1).
        
        /* se for padr∆o-aim substitui 2 @'s por 1 @ */
        IF  p-padrao-aim THEN
            v-conteudo = REPLACE(v-conteudo, "@@":U, "@":U).
        
        /* retira da string o valor do campo e id-final */
        p-string = SUBSTR(p-string, v-pos-id-final + LENGTH(bc-layout-registro-item.id-final)).
        
        /* valida leitura de constante e espaáo */
        RUN decodificaStringVerificaEspeciais (BUFFER bc-layout-registro-item, v-conteudo).
        IF  RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /* grava em tt-campos o campo localizado e seu valor */
        RUN criaTTCampos (pb-layout-registro.sequencia,  
                          pb-layout-registro.num-layout-registro,
                          v-registro, BUFFER bc-layout-registro-item, v-conteudo).

        /* n∆o Ç mais o primeiro campo do registro */        
        v-primeiro-campo = NO.
    END.

    /* Retira id final do seguimento */
    
    IF  p-string BEGINS p-id-seg-fim 
    AND p-id-seg-fim  <> ""
    THEN DO:
        ASSIGN 
               p-string = SUBSTR(p-string, INDEX(p-string, p-id-seg-fim  
                                                 + (IF p-padrao-aim THEN "@":U ELSE "":U))  
                                                 + LENGTH(p-id-seg-fim  
                                                          + (IF p-padrao-aim THEN "@":U ELSE "":U))).        
    END.

    /* Gerar os campos com valores prÇ-fixados, campos fixos */
    RUN carregacampofixo (BUFFER pb-layout-registro, v-registro).
    
    /* Executa EPC para cada registro */    
    RUN executaEPC2D (pb-layout-registro.num-layout-registro,
                      pb-layout-registro.cod-tipo-layout-registro,
                      v-registro,
                      INPUT-OUTPUT TABLE tt-campos).
    
    /* se for ocorrencia unica de registro cai fora */
    IF  pb-layout-registro.ind-ocorrencia = 1 /* ocorrencia unica */ THEN
        LEAVE bloco-leitura-campos.
END.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decodificaStringNovaLinha) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE decodificaStringNovaLinha Procedure 
PROCEDURE decodificaStringNovaLinha :
/*------------------------------------------------------------------------------
  Purpose:     Decodifica o Item NovaLinha na String
  Parameters:  Quantidade, String
  Notes:       Retorna OK ou NOK
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-quant-item        AS CHARACTER NO-UNDO. /* bc-layout-registro.valor-item */
DEF INPUT-OUTPUT PARAM p-string     AS CHARACTER NO-UNDO.
DEF INPUT PARAM p-sequencia         AS INTEGER   NO-UNDO.
DEF INPUT PARAM p-segmento          AS INTEGER   NO-UNDO.
DEF INPUT PARAM p-registro          AS INTEGER   NO-UNDO.

DEF VAR v-quant     AS INTEGER NO-UNDO.
DEF VAR v-cont      AS INTEGER NO-UNDO.

v-quant = MAX(1, INTEGER(p-quant-item)) NO-ERROR.

/* verifica se a string possui nova-linha: chr(10) ou chr(13) + chr(10) */
IF  p-string BEGINS FILL(CHR(10), v-quant)
OR  p-string BEGINS FILL(CHR(13) + CHR(10), v-quant) THEN DO:
    /* retira os new line da string */
    IF  p-string BEGINS FILL(CHR(10), v-quant) THEN
        p-string = SUBSTR(p-string, v-quant + 1).
    ELSE
        p-string = SUBSTR(p-string, v-quant * 2 + 1).
    RETURN "OK":U.
END.
ELSE DO:
    RUN geraTTErro (25959, {clinc/i01cl025.i 4 3}, "":U).
    RETURN "NOK":U.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decodificaStringSeparador) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE decodificaStringSeparador Procedure 
PROCEDURE decodificaStringSeparador :
/*------------------------------------------------------------------------------
  Purpose:     Extrair informaá‰es usando separador de campos
  Parameters:  desc-segmento, bc-layout-registro, string, separador
  Notes:       retorna NOK em caso de erro
------------------------------------------------------------------------------*/

DEF PARAM BUFFER pb-layout-registro     FOR bc-layout-registro.
DEF INPUT-OUTPUT PARAM p-string         AS CHARACTER NO-UNDO.
DEF INPUT PARAM p-sep-campo             AS CHARACTER NO-UNDO.
DEF INPUT PARAM p-sep-linha             AS CHARACTER NO-UNDO.
DEF INPUT PARAM p-id-seg-ini            AS CHARACTER NO-UNDO.
DEF INPUT PARAM p-id-seg-fim            AS CHARACTER NO-UNDO.

DEF VAR v-pos-sep-campo         AS INTEGER   NO-UNDO.
DEF VAR v-pos-sep-linha         AS INTEGER   NO-UNDO.
DEF VAR v-linha                 AS CHARACTER NO-UNDO.
DEF VAR v-conteudo              AS CHARACTER NO-UNDO.
DEF VAR v-registro              AS INTEGER   NO-UNDO.

bloco-leitura-campos:
REPEAT: /* este repeat Ç controlado por bc-layout.ind-ocorrencia */
    
    /* acabou a linha */
    IF  p-string = "":U THEN
        LEAVE bloco-leitura-campos.           

    v-registro = v-registro + 1.
    
    /* primeiro obtem a linha com base no separador de linhas */
    
    IF  p-sep-linha <> "" THEN DO:
        v-pos-sep-linha = INDEX(p-string, p-sep-linha).
    
        IF  v-pos-sep-linha = 0 
        THEN /* n∆o tem separador de linha ou Ç a £ltima linha */
            ASSIGN 
                  v-linha  = p-string.                   
        ELSE
            ASSIGN 
                  v-linha = SUBSTR(p-string, 1, v-pos-sep-linha - 1).
    END.
    ELSE
        ASSIGN v-linha = p-string.
                   
    IF  p-id-seg-ini <> "" THEN DO:

        v-pos-sep-campo = INDEX(v-linha, p-sep-campo).        

        IF  p-id-seg-ini <> SUBSTR(V-LINHA,1,v-pos-sep-campo - 1) 
        THEN DO:
            LEAVE bloco-leitura-campos.           
        END.
        ELSE
            ASSIGN 
                  v-linha = SUBSTR(v-linha,v-pos-sep-campo + 1). /* NAO CONSIDERAR IDENTIFICARDOR DE SEGMENTO */

    END.
    
    /* obtem cada campo do segmento de registro analisando a linha */
    FOR EACH bc-layout-registro-item NO-LOCK
        WHERE bc-layout-registro-item.num-layout-registro = pb-layout-registro.num-layout-registro
        AND   bc-layout-registro-item.tipo-item           <> 6 /* campo fixo */
        BREAK BY bc-layout-registro-item.sequencia:
        
        /* localiza posiá∆o do separador de campo */
        v-pos-sep-campo = INDEX(v-linha, p-sep-campo).               

       

        /* se n∆o achou separador pode ser o ultimo campo da linha (sem separador) */
        IF  v-pos-sep-campo = 0 THEN DO:
            IF  LAST-OF (bc-layout-registro-item.sequencia) THEN DO:
                v-pos-sep-campo = LENGTH(v-linha) + 1.
            END.
            ELSE DO:
                RUN geraTTErro (25956, p-sep-campo 
                                       + "~~":U 
                                       + formataCodLayout(pb-layout-registro.cod-layout, pb-layout-registro.log-datasul, pb-layout-registro.num-versao),
                                       "":U).
                RETURN "NOK":U.
            END.
        END.
        
        /* obtem valor do campo atÇ o separador */
        v-conteudo = SUBSTR(v-linha, 1, v-pos-sep-campo - 1).

        /* retira valor do campo da linha */
        v-linha = SUBSTR(v-linha, v-pos-sep-campo + LENGTH(p-sep-campo)).

        /* valida leitura de constante e espaáo */
        RUN decodificaStringVerificaEspeciais (BUFFER bc-layout-registro-item, v-conteudo).
        IF  RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        /* grava em tt-campos o campo localizado e seu valor */
        RUN criaTTCampos (pb-layout-registro.sequencia,
                          pb-layout-registro.num-layout-registro,
                          v-registro, BUFFER bc-layout-registro-item, v-conteudo).

    END.

    /* Gerar os campos com valores prÇ-fixados, campos fixos */
        
    RUN carregacampofixo (BUFFER pb-layout-registro, v-registro).
          
    /* Executa EPC para cada registro */    
    RUN executaEPC2D (pb-layout-registro.num-layout-registro,
                      pb-layout-registro.cod-tipo-layout-registro,
                      v-registro,
                      INPUT-OUTPUT TABLE tt-campos).

    /*** atualizacao da string de entrada ***/
        
    IF  p-sep-linha = ""  /*sem separador de linha */ 
    THEN /* caso seja uma £nica linha sobrepor a conteudo com o que j† foi lido                  */
        p-string = v-linha.
    ELSE /* retira linha da string  ou finaliza processo com "" pois nao existe mais separadores */
        p-string = IF  v-pos-sep-linha <> 0 
                   THEN 
                       SUBSTR(p-string, MAX(1, v-pos-sep-linha + LENGTH(p-sep-linha)))
                   ELSE 
                       "".    
    /***************************************/
    
    /* se for ocorrencia unica de registro cai fora */
    IF  pb-layout-registro.ind-ocorrencia = 1 /* ocorrencia unica */ 
    THEN
        LEAVE bloco-leitura-campos.

END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decodificaStringTamanhoFixo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE decodificaStringTamanhoFixo Procedure 
PROCEDURE decodificaStringTamanhoFixo :
/*------------------------------------------------------------------------------
  Purpose:     Extrair informaá‰es usando tamanho fixo
  Parameters:  desc-segmento, bc-layout-registro, string
  Notes:       retorna NOK em caso de erro
------------------------------------------------------------------------------*/

DEF PARAM BUFFER pb-layout-registro     FOR bc-layout-registro.
DEF INPUT-OUTPUT PARAM p-string         AS CHARACTER NO-UNDO.
DEF INPUT PARAM p-id-seg-ini            AS CHARACTER NO-UNDO.
DEF INPUT PARAM p-id-seg-fim            AS CHARACTER NO-UNDO.

DEF VAR v-conteudo              AS CHARACTER NO-UNDO.
DEF VAR v-registro              AS INTEGER   NO-UNDO.
DEF VAR v-tamanho               AS INTEGER   NO-UNDO.

bloco-leitura-campos:
REPEAT: /* este repeat Ç controlado por bc-layout.ind-ocorrencia */
    
    IF  p-string = "":U THEN
        LEAVE bloco-leitura-campos.           
    
    v-registro = v-registro + 1.
    
    IF  p-id-seg-ini <> "" THEN DO:

        IF  p-id-seg-ini <> SUBSTR(p-string,1,LENGTH(p-id-seg-ini)) 
        THEN
            LEAVE bloco-leitura-campos.           
        ELSE 
            ASSIGN 
                  p-string = SUBSTR(p-string,LENGTH(p-id-seg-ini) + 1). /* NAO CONSIDERAR IDENTIFICARDOR DE SEGMENTO */
    END.

    /* obtem cada campo do segmento de registro */
    FOR EACH bc-layout-registro-item NO-LOCK
        WHERE bc-layout-registro-item.num-layout-registro = pb-layout-registro.num-layout-registro
        AND   bc-layout-registro-item.tipo-item <> 6 /* campo fixo */:

        /* tratamento de nova linha */
        IF  bc-layout-registro-item.tipo-item = 3 /* nova linha */ THEN DO:
            RUN decodificaStringNovaLinha (bc-layout-registro-item.valor-item, 
                                           INPUT-OUTPUT p-string,
                                           pb-layout-registro.sequencia,
                                           pb-layout-registro.num-layout-registro,
                                           v-registro).
            IF  RETURN-VALUE = "OK":U THEN
                NEXT.
            IF  RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
        END.

        /* determina tamanho do campo com base no tipo-item e formato */
        IF  bc-layout-registro-item.tipo-item = 2 /* constante */ THEN
            v-tamanho = LENGTH(bc-layout-registro-item.valor-item).
        ELSE
        IF  bc-layout-registro-item.tipo-item = 4 /* espaáo */ THEN
            v-tamanho = MAX(1, INTEGER(bc-layout-registro-item.valor-item)).
        ELSE
            v-tamanho = LENGTH(STRING("":U, bc-layout-registro-item.formato)).
        
        /* obtem valor do campo de acordo com tamanho */
        v-conteudo = SUBSTR(p-string, 1, v-tamanho).
        
        /* retira valor do campo da string */
        p-string = SUBSTR(p-string, v-tamanho + 1).
        
        /* valida leitura de constante e espaáo */
        RUN decodificaStringVerificaEspeciais (BUFFER bc-layout-registro-item, v-conteudo).
        IF  RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /* grava em tt-campos o campo localizado e seu valor */
        RUN criaTTCampos (pb-layout-registro.sequencia,
                          pb-layout-registro.num-layout-registro,
                          v-registro, BUFFER bc-layout-registro-item, v-conteudo).

    END.
    
     /* Gerar os campos com valores prÇ-fixados, campos fixos */

    RUN carregacampofixo (BUFFER pb-layout-registro, v-registro).

    /* Executa EPC para cada registro */    
    RUN executaEPC2D (pb-layout-registro.num-layout-registro,
                      pb-layout-registro.cod-tipo-layout-registro,
                      v-registro,
                      INPUT-OUTPUT TABLE tt-campos).

    /* se for ocorrencia unica de registro cai fora */
    IF  pb-layout-registro.ind-ocorrencia = 1 /* ocorrencia unica */ THEN
        LEAVE bloco-leitura-campos.
        
    /* acabou dados da string */
    IF  p-string = "":U THEN
        LEAVE bloco-leitura-campos.
END.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decodificaStringVerificaEspeciais) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE decodificaStringVerificaEspeciais Procedure 
PROCEDURE decodificaStringVerificaEspeciais :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se constante ou espacos foram lidos
  Parameters:  bc-layout-registro-item e conteudo
  Notes:       retorna "NOK" em caso de erro
------------------------------------------------------------------------------*/

DEF PARAM BUFFER pb-layout-registro-item       FOR bc-layout-registro-item.
DEF INPUT PARAM p-conteudo                     AS CHARACTER NO-UNDO.
 
/* se for constante ou espaáos verifica se os mesmos foram lidos */
IF  pb-layout-registro-item.tipo-item = 2 /* constante */ 
AND p-conteudo <> bc-layout-registro-item.valor-item THEN DO:
    RUN geraTTErro (25959, pb-layout-registro-item.valor-item, "":U).
    RETURN "NOK":U.
END.
IF  pb-layout-registro-item.tipo-item = 4 /* espaáos */
AND p-conteudo <> FILL(" ", MAX(1, INTEGER(pb-layout-registro-item.valor-item))) THEN DO:
    RUN geraTTErro (25959, FILL(" ", MAX(1, INTEGER(pb-layout-registro-item.valor-item))), "":U).
    RETURN "NOK":U.
END.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-executaEPC2D) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executaEPC2D Procedure 
PROCEDURE executaEPC2D :
/*------------------------------------------------------------------------------
  Purpose:     Executa EPC para evento 2D-Input
  Parameters:  segmento, tipo-registro, num-registro, tt-campos
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-segmento          AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-tipo-registro     AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-num-registro      AS INTEGER NO-UNDO.
    DEF INPUT-OUTPUT PARAM TABLE        FOR tt-campos.

    &SCOPED-DEFINE EPC2D-Event  "2D-Input":U
    
    /* Somente chama epc se foi gerado registros em tt-campos */
    FIND FIRST tt-campos
        WHERE tt-campos.segmento = p-segmento
        NO-ERROR.
    IF  NOT AVAIL tt-campos THEN
        RETURN.
        
    EMPTY TEMP-TABLE tt-epc.
    
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = {&EPC2D-Event}
           tt-epc.cod-parameter = "Segment/Record":U
           tt-epc.val-parameter = STRING(p-tipo-registro) + "/":U + STRING(p-num-registro).
    
    FOR EACH tt-campos
        WHERE tt-campos.segmento = p-segmento
          AND tt-campos.registro = p-num-registro:
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = {&EPC2D-Event}
               tt-epc.cod-parameter = tt-campos.campo
               tt-epc.val-parameter = tt-campos.valor.
    END.
           
    {include/i-epc201.i {&EPC2D-Event}}
    
    FOR EACH tt-epc,
        EACH tt-campos
            WHERE tt-campos.segmento = p-segmento
              AND tt-campos.registro = p-num-registro
              AND tt-campos.campo    = tt-epc.cod-parameter:
        tt-campos.valor = tt-epc.val-parameter.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-geraErroID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraErroID Procedure 
PROCEDURE geraErroID :
/*------------------------------------------------------------------------------
  Purpose:     Geraá∆o do Erro do ID Inicial e Final
  Parameters:  Inicial/Final, bc-layout-registro-item, bc-layout-registro
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-id                        AS CHARACTER NO-UNDO.
DEF PARAM BUFFER pb-layout-registro-item    FOR bc-layout-registro-item.
DEF PARAM BUFFER pb-layout-registro         FOR bc-layout-registro.

RUN geraTTErro (25965, p-id 
                       + "~~":U +
                       (IF bc-layout-registro-item.tipo-item = 4 /* espaáo */ 
                        THEN {clinc/i01cl025.i 4 4}
                        ELSE bc-layout-registro-item.valor-item) 
                       + "~~":U 
                       + formataCodLayout(pb-layout-registro.cod-layout, pb-layout-registro.log-datasul, pb-layout-registro.num-versao),
                       "":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemLayout Procedure 
PROCEDURE obtemLayout :
/*------------------------------------------------------------------------------
  Purpose:     Com base no nome-abrev, busca o layout da etiqueta
  Parameters:  nome-abrev, buffer bc-layout
  Notes:       retorna no param buffer o registro de layout do emitente
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-nome-abrev        AS CHARACTER NO-UNDO.
DEF INPUT PARAM p-transacao          AS CHARACTER NO-UNDO.
DEF PARAM BUFFER pb-layout          FOR bc-layout.

DEF VAR h-bcapi017                  AS HANDLE NO-UNDO.
/* usa bcapi017 para buscar layout do cliente */
RUN bcp/bcapi017.p PERSISTENT SET h-bcapi017.
RUN obtemLayout2D IN h-bcapi017 (1 /* entrada */, p-nome-abrev, p-transacao ,BUFFER pb-layout, INPUT-OUTPUT TABLE tt-erro).
DELETE PROCEDURE h-bcapi017.

/* Valida indicador de leitura */
IF  pb-layout.ind-leitura-campo < 2
OR  pb-layout.ind-leitura-campo > 5 THEN DO:
    RUN geraTTErro (25945, formataCodLayout(pb-layout.cod-layout, pb-layout.log-datasul, pb-layout.num-versao), "":U).
    RETURN "NOK":U.
END.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

