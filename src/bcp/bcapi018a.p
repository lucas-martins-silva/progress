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
{include/i-prgvrs.i BCAPI018A 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPI018A MUT}
&ENDIF


/*------------------------------------------------------------------------
    File        : bcapi018a.p
    Purpose     : Rotina de Gera»’o de Etiqueta 2D

    Syntax      : run bcp/bcapi018a.p (tipo-etiq, num-versao, cd-trans, 
                                       tt-campos, tt-erro)

    Description : Gera etiqueta conforme tipo-etiq e tt-campos
                  Apenas trata etiquetas 2D. Tem alguns controles para 1D 
                  mas sem efeito por enquanto.

    Author(s)   : Alcides Schulz
    Created     : Janeiro/2001
    Notes       : Pode ser chamada para executar teste
                
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{include/i_dbvers.i} /* Defini»’o do pr²-processador */
{cdp/cd0666.i}                      /* Definicao da temp-table de erros  */
{bcp/bc1000.i &local=BCAPI018A}     /* procedure geraTTErro */
{bcp/bcapi019.i}                    /* Temp-table tt-campos */
{bcp/bc1001.i}                      /* Tratamento destino de gera»’o */
{bcp/bc1002.i}                      /* Leitura de Dados de tt-campos */
/*** variaveis globais ***/
{utp/ut-glob.i}

{cdp/cdcfgint.i}                    /* versao do produto */

DEF INPUT PARAM p-tipo-etiq     AS INTEGER      NO-UNDO.
DEF INPUT PARAM p-num-versao    AS INTEGER      NO-UNDO.
DEF INPUT PARAM p-cd-trans      AS CHARACTER    NO-UNDO.
DEF INPUT PARAM p-arquivo       AS CHARACTER    NO-UNDO.
DEF INPUT PARAM p-quantidade    AS INTEGER      NO-UNDO.
DEF INPUT PARAM TABLE           FOR tt-campos.
DEF INPUT-OUTPUT PARAM TABLE    FOR tt-erro.

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

    DEF VAR v-cont      AS INTEGER NO-UNDO.
    
    REPEAT v-cont = 1 TO MAX(1, p-quantidade):
        RUN geraEtiqueta.
        FIND FIRST tt-erro NO-ERROR.
        IF  AVAIL tt-erro THEN
            RETURN "NOK":U.
    END.
    RETURN "OK":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-enviaCampo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviaCampo Procedure 
PROCEDURE enviaCampo :
/*------------------------------------------------------------------------------
  Purpose:     Envia o campo para destino de sa­da
  Parameters:  bc-layout, bc-layout-registro, bc-layout-registro-item, registro
  Notes:       Monta uma string com o valor do campo e ID‹s.
------------------------------------------------------------------------------*/

DEF PARAM BUFFER pb-layout      FOR bc-layout.
DEF PARAM BUFFER pb-registro    FOR bc-layout-registro.
DEF PARAM BUFFER pb-item        FOR bc-layout-registro-item.
DEF INPUT PARAM p-registro      AS INTEGER NO-UNDO.

DEF VAR v-string                AS CHARACTER NO-UNDO.
DEF VAR v-valor-campo           AS CHARACTER NO-UNDO.
DEF VAR v-decimal               AS INTEGER   NO-UNDO.
DEF VAR v-valor-aux             AS CHARACTER NO-UNDO.
DEF VAR v-formato               AS CHARACTER NO-UNDO.
DEF VAR l-valor                 AS LOGICAL   NO-UNDO.
DEF VAR de-valor                AS DECIMAL   NO-UNDO.
DEF VAR c-hor                   AS CHARACTER NO-UNDO.
DEF VAR c-min                   AS CHARACTER NO-UNDO.
DEF VAR c-seg                   AS CHARACTER NO-UNDO.
DEF VAR c-valor-item            AS CHARACTER NO-UNDO.
DEF VAR c-valor-campo           AS CHARACTER NO-UNDO.


    /* envia ID-Inicial se for o caso */
    IF  pb-layout.ind-leitura-campo = 4 /* identificador */
    OR  pb-layout.ind-leitura-campo = 5 /* AIMBrasil */ THEN
        v-string = pb-item.id-inicial.
        
    /* obtem valor do campo conforme tipo */

    &IF  '{&mgcld_version}' > '2.04' 
    &THEN
    ASSIGN c-valor-campo = pb-item.valor-campo.
    &ELSE
    ASSIGN c-valor-campo = pb-item.char-2.
    &ENDIF                               

    CASE pb-item.tipo-item:
        WHEN 1 /* tabela.campo */ OR 
        WHEN 5 /* auxiliar */ THEN DO:
            
            RUN obtemValorCampo (pb-registro.num-layout-registro, p-registro,
                                 pb-item.valor-item, OUTPUT v-valor-campo,OUTPUT v-decimal).        

            /************* TRATAMENTO DE DATAS *************/
            IF  pb-item.tipo-dado = "DATE":U 
            THEN DO:
                 
                IF index(pb-item.formato,"D":U) > 0
                OR index(pb-item.formato,"M":U) > 0
                OR index(pb-item.formato,"Y":U) > 0
                OR index(pb-item.formato,"A":U) > 0
                THEN DO:
                    
                    ASSIGN v-formato   = REPLACE(pb-item.formato,"Y":U,"A":U)
                           v-valor-aux = v-formato.
                                                                        
                    ASSIGN SUBSTRING(v-valor-aux,INDEX(v-formato,"DD":U),2) = STRING(DAY(DATE(V-VALOR-CAMPO)),"99":U) NO-ERROR.

                    ASSIGN SUBSTRING(v-valor-aux,INDEX(v-formato,"MM":U),2) = STRING(MONTH(DATE(V-VALOR-CAMPO)),"99":U) NO-ERROR.
                    
                    IF INDEX(v-formato,"AAAA":U) > 0 
                    THEN
                        ASSIGN SUBSTRING(v-valor-aux,INDEX(v-formato,"AAAA":U),4) = STRING(YEAR(DATE(V-VALOR-CAMPO)),"9999":U) NO-ERROR.
                    ELSE
                        IF INDEX(v-formato,"AA":U)  > 0    
                        THEN
                            ASSIGN SUBSTRING(v-valor-aux,INDEX(v-formato,"AA":U),2) = SUBSTR(string(YEAR(DATE(V-VALOR-CAMPO)),"9999":U),3,2) NO-ERROR.
                
                    ASSIGN v-valor-campo = (IF v-valor-aux = ? THEN v-valor-campo ELSE v-valor-aux). 
                
                END.
                
            END.       

            /********* TRATAMENTO DE DECIMAL ***********/
            
            IF  pb-item.tipo-dado = "DECIMAL":U 
            THEN DO:
                 
                ASSIGN de-valor       = DEC(v-valor-campo) NO-ERROR.
                ASSIGN v-valor-campo = RIGHT-TRIM(LEFT-TRIM(string(de-valor * EXP(10,int(v-decimal)),pb-item.formato))) NO-ERROR.


            END.
                
            /********* TRATAMENTO DE LOGICO ***********/

            IF  pb-item.tipo-dado = "LOGICAL":U 
            THEN DO:
              
                ASSIGN l-valor = IF  v-valor-campo = "YES":U THEN YES ELSE NO NO-ERROR.
                ASSIGN v-valor-campo = string(l-valor,pb-item.formato) NO-ERROR.
            
            END.

            /******************************/

        END.
        WHEN 6 /* campo fixo */ THEN DO:

            ASSIGN v-valor-campo = c-valor-campo.

            IF  INDEX(c-valor-campo,"FNC-TODAY":U) > 0 THEN DO: 

                IF  INDEX(pb-item.FORMATO,"D":U) > 0  
                OR  INDEX(pb-item.FORMATO,"M":U) > 0  
                OR  INDEX(pb-item.FORMATO,"A":U) > 0  
                OR  INDEX(pb-item.FORMATO,"Y":U) > 0  
                THEN  DO:
            
                    ASSIGN 
                           v-valor-campo = REPLACE(v-valor-campo,"YY":U,"AA":U) NO-ERROR.
            
                    IF  index(v-valor-campo,"DD":U) <> 0 
                    THEN
                        ASSIGN SUBSTRING(v-valor-campo,index(v-valor-campo,"DD":U)) = STRING(DAY(TODAY),"99":U) NO-ERROR.
            
                    IF  index(v-valor-campo,"MM":U) <> 0 
                    THEN
                        ASSIGN SUBSTRING(v-valor-campo,index(v-valor-campo,"MM":U)) = STRING(MONTH(TODAY),"99":U) NO-ERROR.
            
                    IF  index(v-valor-campo,"AAAA":U) <> 0 
                    THEN
                        ASSIGN SUBSTRING(v-valor-campo,index(v-valor-campo,"AAAA":U)) = STRING(YEAR(TODAY),"9999":U) NO-ERROR.
                    ELSE 
                        IF  index(v-valor-campo,"AA":U) <> 0 
                        THEN
                            ASSIGN SUBSTRING(v-valor-campo,index(v-valor-campo,"AA":U)) = SUBSTRING(STRING(YEAR(TODAY),"9999":U),3,2) NO-ERROR.
                END.
                ELSE 
                    ASSIGN v-valor-campo = STRING(TODAY,pb-item.FORMATO). 
            END.
                        
            IF  c-valor-campo = "FNC-TIME":U 
            THEN DO:
                ASSIGN c-hor = SUBSTRING(STRING(TIME,"hh:mm:ss":U),1,2)
                       c-min = SUBSTRING(STRING(TIME,"hh:mm:ss":U),4,2)
                       c-seg = SUBSTRING(STRING(TIME,"hh:mm:ss":U),7,2)
                       v-valor-campo = pb-item.FORMATO NO-ERROR.
                
                IF  index(v-valor-campo,"HH":U) <> 0 
                OR  index(v-valor-campo,"MM":U) <> 0
                OR  index(v-valor-campo,"SS":U) <> 0
                THEN DO:
                
                    IF  index(v-valor-campo,"HH":U) <> 0 
                    THEN
                        ASSIGN SUBSTRING(v-valor-campo,index(v-valor-campo,"HH":U)) = c-hor NO-ERROR.
    
                    IF  index(v-valor-campo,"MM":U) <> 0 
                    THEN
                        ASSIGN SUBSTRING(v-valor-campo,index(v-valor-campo,"MM":U)) = c-min NO-ERROR.
                    
                    IF  index(v-valor-campo,"SS":U) <> 0 
                    THEN
                        ASSIGN SUBSTRING(v-valor-campo,index(v-valor-campo,"SS":U)) = c-seg NO-ERROR.                
                END.
                ELSE 
                    ASSIGN v-valor-campo = STRING(TIME,"hh:mm:ss":U).
            END.
                
            IF  c-valor-campo = "FNC-USER":U 
            THEN            
                ASSIGN v-valor-campo = IF  
                    &if '{&mgcld_version}' <= '2.04' &then
                        PARAM-BC.INT-2
                    &else
                        PARAM-BC.ind-sistema
                    &endif 
                    = 1 THEN STRING(C-SEG-USUARIO,pb-item.FORMATO)
                                       ELSE string(USERID("MGADM":U),pb-item.FORMATO) NO-ERROR. 
            
            IF  c-valor-campo = "FNC-COMPANY":U 
            THEN
                ASSIGN v-valor-campo = STRING(i-ep-codigo-usuario,pb-item.FORMATO) NO-ERROR.
                    
            IF  c-valor-campo = "FNC-NUMBER-RECORD":U 
            THEN
                ASSIGN v-valor-campo = STRING(p-registro,pb-item.FORMATO) NO-ERROR.


        END.
        WHEN 2 THEN DO: /* constante */
            v-valor-campo = pb-item.valor-item.
        END.
        WHEN 3 THEN DO: /* nova linha */
            v-valor-campo = FILL(CHR(10), INTEGER(pb-item.valor-item)).
        END.
        WHEN 4 THEN DO: /* espa»o */
            v-valor-campo = FILL(" ":U, INTEGER(pb-item.valor-item)).
        END.
    END CASE.
                                      
    /* adiciona valor do campo a string */
    IF  pb-item.pos-inicial > 1 THEN
        v-valor-campo = SUBSTR(v-valor-campo, pb-item.pos-inicial).
    
    IF  pb-layout.ind-leitura-campo = 2 /* tamanho fixo */ THEN DO:

        IF  pb-item.tipo-dado = "LOGICAL":U   /* TIPOS Jæ TRATADOS SEPARADAMENTE */ 
        OR  pb-item.tipo-dado = "DATE":U
        OR  pb-item.tipo-dado = "DECIMAL":U
        THEN
            v-string = v-string + v-valor-campo.
        ELSE
            v-string = v-string + STRING(v-valor-campo, pb-item.formato).
    END.
    ELSE
        v-string = v-string + v-valor-campo.
    
    /* id-final */
    IF  pb-layout.ind-leitura-campo = 4 /* identificador */
    OR  pb-layout.ind-leitura-campo = 5 /* AIMBrasil */ THEN
        v-string = v-string + pb-item.id-final + (IF pb-layout.ind-leitura-campo = 5 THEN "@":U ELSE "":U).                                         
        
    /* envia serparador de campos */
    IF  pb-layout.ind-leitura-campo = 3 /* separador */ THEN
        v-string = v-string + pb-layout.separador-campos.

    /* envia string para destino de gera»’o (BC10001.I) */
    RUN enviaString (v-string).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-geraEtiqueta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraEtiqueta Procedure 
PROCEDURE geraEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     Logica principal da geracao da etiqueta
  Parameters:  <none>
  Notes:       Usa o campo bc-layout.ind-leitura-campo para gera»’o dos dados.
------------------------------------------------------------------------------*/

    DEF VAR v-quant-registro    AS INTEGER   NO-UNDO.
    DEF VAR v-cont              AS INTEGER   NO-UNDO.
    DEF VAR v-valor-campo       AS CHARACTER NO-UNDO.
    DEF VAR C-TAG               AS CHARACTER NO-UNDO.
    DEF VAR c-indicador-ini            AS CHARACTER NO-UNDO.
    DEF VAR c-indicador-fim            AS CHARACTER NO-UNDO.

    /* le tipo-etiqueta para obter layout */
    FIND tipo-etiqueta NO-LOCK
        WHERE tipo-etiqueta.tipo-etiq = p-tipo-etiq
        NO-ERROR.
    IF  NOT AVAIL tipo-etiqueta THEN DO:
        {utp/ut-table.i mgcld tipo-etiqueta 1}
        RUN geraTTErro (2, TRIM(RETURN-VALUE), STRING(p-tipo-etiq)).
        RETURN.
    END.
    
    /* somente trata etiqueta 2D */
    
&if '{&mgcld_version}' >= '2.04' &then
    IF  tipo-etiqueta.ind-dimensao <> 2 /* 2D */ THEN DO:
&else
    IF tipo-etiqueta.int-2 <> 2 /* 2D */ THEN DO:
&endif 
 
 
        RUN geraTTErro (25939, STRING(p-tipo-etiq), "":U).
        RETURN.
    END.
    
    /* abre o destino de gera»’o (bc1001.i)*/
    RUN abreDestinoGeracao (p-tipo-etiq, p-cd-trans, p-arquivo).
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN.

    /* le o layout da transa»’o */
    FIND bc-layout
&if '{&mgcld_version}' >= '2.04' &then
        WHERE bc-layout.cod-layout  = tipo-etiqueta.cod-layout
          AND bc-layout.log-datasul = tipo-etiqueta.log-datasul
&else
        WHERE bc-layout.cod-layout  = tipo-etiqueta.int-1
          AND bc-layout.log-datasul = tipo-etiqueta.log-1
&endif
          AND bc-layout.num-versao  = p-num-versao
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL bc-layout THEN DO:
        {utp/ut-table.i mgcld bc-layout 1}
&if '{&mgcld_version}' >= '2.04' &then
        RUN geraTTErro (2, TRIM(RETURN-VALUE), STRING(tipo-etiqueta.cod-layout)).
&else
        RUN geraTTErro (2, TRIM(RETURN-VALUE), STRING(tipo-etiqueta.int-1)).
&endif
        RETURN.
    END.
    
    /* etiqueta 2D gera apenas 1 linha para todos os registros */
&if '{&mgcld_version}' >= '2.04' &then
    IF  tipo-etiqueta.ind-dimensao = 2 /*2D*/ THEN
&else
    IF  tipo-etiqueta.int-2 = 2 /*2D*/ THEN
&endif



        RUN iniciaLinha. /* bc1001.i */
   
    /* gera»’o da etiqueta */
    FOR EACH bc-layout-registro NO-LOCK
        WHERE bc-layout-registro.cod-layout  = bc-layout.cod-layout
          AND bc-layout-registro.log-datasul = bc-layout.log-datasul
          AND bc-layout-registro.num-versao  = bc-layout.num-versao:

        RUN obtemQuantRegistro (bc-layout-registro.num-layout-registro, OUTPUT v-quant-registro).

        /* imprime cada layout 1 vez para cada registro */
        /* tratamento para rodap² e cabe»alho
           quando um rodap² ou cabecalho possuirem constantes, mesmo 
           sem dados eles ser’o apresentados.
           Isto para tratar quest„es de inicilizac’o e finaliza»’o de comandos de
           impress’o */
        
        IF  v-quant-registro = 0 
        AND (   bc-layout-registro.cod-tipo-layout-registro = 1  /* cabecalho */
             OR bc-layout-registro.cod-tipo-layout-registro = 9) /* rodap²    */
        THEN DO:
            
            FIND FIRST bc-layout-registro-item NO-LOCK
                 WHERE bc-layout-registro-item.num-layout-registro = bc-layout-registro.num-layout-registro
                 AND   bc-layout-registro-item.tipo-item           = 2 /* contante */
                 NO-ERROR.

            IF AVAIL bc-layout-registro-item 
            THEN
                ASSIGN v-quant-registro = 1.
        END.

        /***********************************************/

        REPEAT v-cont = 1 TO v-quant-registro:
            
            /* tratamento para padr’o AIM: inicio do grupo de produto */

            &IF  '{&mgcld_version}' > '2.04' 
            &THEN
            ASSIGN c-indicador-ini = bc-layout-registro.indicador-ini
                   c-indicador-fim = bc-layout-registro.indicador-fim.
             
            &ELSE
            ASSIGN c-indicador-ini = bc-layout-registro.char-1
                   c-indicador-fim = bc-layout-registro.char-2.
            &ENDIF

            IF   bc-layout.ind-leitura-campo =  5 /* AIMBrasil */ 
            AND  c-indicador-ini   <> ""
            THEN DO:
                     
                 IF  index(c-indicador-ini,"IT") > 0  
                 THEN 
                     RUN enviaString (c-indicador-ini + "@":U).
                 ELSE 
                     RUN enviaString (c-indicador-ini + STRING(v-cont) + "@":U).

            END.
                          
            /* Coloca id inicial para os demais tipo */
            IF  bc-layout.ind-leitura-campo <> 5 /* AIMBrasil */ 
            AND c-indicador-ini   <> ""
            THEN DO:
                
                RUN enviaString (c-indicador-ini).

                /* envia separador de campo se for o caso */
                IF  bc-layout.ind-leitura-campo = 3
                AND bc-layout.separador-campos <> "":U THEN
                    RUN enviaString (bc-layout.separador-campos).

            END.
            
            /* etiqueta 1D gera 1 linha para registro */
&if '{&mgcld_version}' >= '2.04' &then
            IF  tipo-etiqueta.ind-dimensao = 1 /* 1D */ THEN
&else
            IF tipo-etiqueta.int-2 = 1 /* 1D */ THEN
&endif
                RUN iniciaLinha. /* bc1001.i */
            
            FOR EACH bc-layout-registro-item NO-LOCK
                WHERE bc-layout-registro-item.num-layout-registro = bc-layout-registro.num-layout-registro:
                RUN enviaCampo (BUFFER bc-layout, BUFFER bc-layout-registro, 
                                BUFFER bc-layout-registro-item, v-cont).
            END.
            
            /* Caso exitam finalizador de serÿ impresso - AIM TEM TRATAMENTO DIFERNTE */
            IF  c-indicador-fim              <> ""            
            AND bc-layout.ind-leitura-campo  <> 5              
            THEN DO:
                
                RUN enviaString (c-indicador-fim).
            
            END.

            /* envia separador de linha se for o caso */
            IF  bc-layout.ind-leitura-campo = 3
            &IF  '{&mgcld_version}' > '2.04' 
            &THEN
            AND bc-layout.separador-linhas <> "":U THEN
                RUN enviaString (bc-layout.separador-linhas).            
            &ELSE
            AND bc-layout.cod-aux[1] <> "":U THEN
                RUN enviaString (bc-layout.cod-aux[1]).
            &ENDIF


            /* etiqueta 1D gera 1 linha para registro */
&if '{&mgcld_version}' >= '2.04' &then
            IF  tipo-etiqueta.ind-dimensao = 1 /* 1D */ THEN
&else
            IF  tipo-etiqueta.int-2 = 1 /* 1D */ THEN
&endif
                RUN encerraLinha. /* bc1001.i */
        END.
        
        /* Caso seja AIM finaliza tag do seguimento */
        IF  c-indicador-fim                      <> ""
        AND index(c-indicador-fim,"FT")           = 0 /* tratamento do fim de arquivo iam */
        AND bc-layout.ind-leitura-campo           = 5              
        THEN 
            RUN enviaString (c-indicador-fim + "@":U).

    END.
    
    IF  bc-layout.ind-leitura-campo = 5 /* AIMBrasil */ 
    THEN   
        RUN enviaString ("FT@":U).
    
    /* etiqueta 2D gera 1 linha para todos os registros */
&if '{&mgcld_version}' >= '2.04' &then
    IF  tipo-etiqueta.ind-dimensao = 2 /*2D*/
&else
    IF  tipo-etiqueta.int-2 = 2 /*2D*/
&endif
    THEN
        RUN encerraLinha. /* bc1001.i */

    /* fechamento do arquivo de saida (bc1001.i) */
    RUN fechaDestinoGeracao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


