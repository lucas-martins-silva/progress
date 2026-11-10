/********************************************************************************
** Copyright TOTVS S.A. (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0511A 2.00.00.005 } /*** "010005" 03/03/2025 09:11:43  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0511A MAQ}
&ENDIF

/****************** Defini‡Æo de Tabelas Tempor rias do Relat¢rio **********************/

{aqp/aq0511.i} /*tt-param*/

    
/* recebimento de parƒmetros */
DEFINE INPUT PARAMETER TABLE FOR tt-produtor.
DEFINE INPUT PARAMETER TABLE FOR tt-param.

/* include padrÆo para vari veis de relat¢rio  */
{include/i-rpvar.i}

/* defini‡Æo de vari veis  */
DEFINE VARIABLE h-acomp     AS HANDLE    NO-UNDO.

DEFINE VARIABLE c-tit-relat       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-grp-produt   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-produt-rural AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-descricao    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-propried     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-pto-coleta   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-qtd-total    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-total        AS CHARACTER NO-UNDO.

DEFINE VARIABLE i-total     AS INTEGER NO-UNDO.
DEFINE VARIABLE iColuna     AS INTEGER NO-UNDO.
DEFINE VARIABLE iNumColunas AS INTEGER NO-UNDO.
DEFINE VARIABLE iLinha      AS INTEGER NO-UNDO.
DEFINE VARIABLE iQtdGrupo   AS INTEGER NO-UNDO.

{utp/utapi013.i} /* include para exportaŒão Excel */
{cdp/cd0666.i}   /* Definicao da tt-erro */

DEFINE TEMP-TABLE tt-total 
    FIELD dia AS INTEGER
    FIELD qtd AS INTEGER.

DEFINE TEMP-TABLE tt-tot-dia
    FIELD cdn-grp-produt AS INTEGER
    FIELD dia AS INTEGER
    FIELD qtd AS INTEGER.

/*------------------------------------------------------------------------------
Purpose:    Retornar o numero de colunas da planilha conforme dias do mˆs.
Parameters: c-periodo (input): Per¡odo corrente (character)
Notes:      
------------------------------------------------------------------------------*/
FUNCTION retornaDiasMes RETURNS INTEGER (INPUT c-periodo AS CHARACTER):
    DEFINE VARIABLE i-mes  AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-ano  AS INTEGER NO-UNDO.
    DEFINE VARIABLE c-data AS DATE    NO-UNDO.

    IF INT(ENTRY(1,c-periodo , '/')) + 1 > 12 THEN
        ASSIGN i-mes = 1
               i-ano = int(ENTRY(2,c-periodo , '/')) + 1.
    ELSE 
        ASSIGN i-mes = int(ENTRY(1,c-periodo , '/'))+ 1
               i-ano = int(ENTRY(2,c-periodo , '/')).

    ASSIGN c-data = date('01/' + STRING(i-mes,'99') + "/" + string(i-ano,'9999')) - 1.

    RETURN INT(ENTRY(1, STRING(c-data), '/')).
END.


PROCEDURE cria-tt-dados:
    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num          = 1
           tt-dados.planilha-num         = 1 
           tt-dados.celula-coluna        = iColuna
           tt-dados.celula-linha         = iLinha
           tt-dados.celula-fonte-nome    = "Arial":U    
           tt-dados.celula-fonte-tamanho = 08      
           tt-dados.celula-cor-interior  = 2
           tt-dados.celula-fonte-negrito = YES
           tt-dados.celula-fonte-cor     = 01.

    RETURN "OK":U.
END PROCEDURE.

/* ***************************  Main Block  *************************** */
FIND FIRST param-global NO-LOCK NO-ERROR.

FIND empresa WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK NO-ERROR.

ASSIGN c-empresa   = (IF AVAIL param-global THEN param-global.grupo ELSE "")
       c-programa  = "AQ0511".

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

{utp/ut-liter.i Gerando_Planilha *}
RUN pi-inicializar IN h-acomp (INPUT TRIM(RETURN-VALUE)).

FIND FIRST tt-param NO-LOCK NO-ERROR.
ASSIGN tt-param.arquivo = ENTRY(1, tt-param.arquivo, '.') + ".xls":U.
OS-DELETE VALUE(tt-param.arquivo).

/*----------------GERANDO ARQUIVO*/  
{utp/ut-liter.i Di rio_de_Aquisi‡Æo *}
ASSIGN c-tit-relat = RETURN-VALUE.

CREATE tt-configuracao2.
ASSIGN tt-configuracao2.versao-integracao   = 1
       tt-configuracao2.arquivo-num         = 1
       tt-configuracao2.arquivo             = tt-param.arquivo
       tt-configuracao2.total-planilhas      = 1
       tt-configuracao2.exibir-construcao   = NO
       tt-configuracao2.abrir-excel-termino = YES
       tt-configuracao2.imprimir            = NO
       tt-configuracao2.orientacao          = 2.

CREATE tt-planilha2.
ASSIGN tt-planilha2.arquivo-num        = 1
       tt-planilha2.planilha-num       = 1 
       tt-planilha2.planilha-nome      = c-tit-relat
       tt-planilha2.linhas-grade       = YES
       tt-planilha2.largura-coluna[2]  = 40
       tt-planilha2.largura-coluna[3]  = 40
       tt-planilha2.largura-coluna[4]  = 40
       tt-planilha2.largura-coluna[5]  = 8 
       tt-planilha2.largura-coluna[6]  = 8 
       tt-planilha2.largura-coluna[7]  = 8 
       tt-planilha2.largura-coluna[8]  = 8 
       tt-planilha2.largura-coluna[9]  = 8 
       tt-planilha2.largura-coluna[10] = 8
       tt-planilha2.largura-coluna[11] = 8
       tt-planilha2.largura-coluna[12] = 8
       tt-planilha2.largura-coluna[13] = 8
       tt-planilha2.largura-coluna[14] = 8
       tt-planilha2.largura-coluna[15] = 8
       tt-planilha2.largura-coluna[16] = 8
       tt-planilha2.largura-coluna[17] = 8
       tt-planilha2.largura-coluna[18] = 8
       tt-planilha2.largura-coluna[19] = 8
       tt-planilha2.largura-coluna[20] = 8
       tt-planilha2.largura-coluna[21] = 8
       tt-planilha2.largura-coluna[22] = 8
       tt-planilha2.largura-coluna[23] = 8
       tt-planilha2.largura-coluna[24] = 8
       tt-planilha2.largura-coluna[25] = 8
       tt-planilha2.largura-coluna[26] = 8
       tt-planilha2.largura-coluna[27] = 8
       tt-planilha2.largura-coluna[28] = 8
       tt-planilha2.largura-coluna[29] = 8
       tt-planilha2.largura-coluna[30] = 8
       tt-planilha2.largura-coluna[31] = 8
       tt-planilha2.largura-coluna[32] = 8
       tt-planilha2.largura-coluna[33] = 8
       tt-planilha2.largura-coluna[34] = 8
       tt-planilha2.largura-coluna[35]  = 8 
       tt-planilha2.largura-coluna[36] = 12
       tt-planilha2.largura-coluna[37] = 12
       tt-planilha2.formatar-planilha  = YES
       tt-planilha2.formatar-faixa     = YES.


/* Dias do mˆs + colunas Produtor, Descri‡Æo, Propriedade e TOTAL*/
ASSIGN iNumColunas = retornaDiasMes(INPUT tt-param.period) + 5.

ASSIGN iLinha = 1.

/* CRIA CABECALHO PRINCIPAL */
{utp/ut-liter.i Mapa_de_Entrada_de_Produtos_Rurais *}
ASSIGN c-tit-relat = RETURN-VALUE.

DO iColuna = 1 TO iNumColunas:
    RUN cria-tt-dados.
    ASSIGN tt-dados.celula-tipo-borda-inf = 02
           tt-dados.celula-tipo-borda-sup = 02.

    CASE iColuna:
        WHEN 1 THEN 
            ASSIGN tt-dados.celula-valor          = c-empresa
                   tt-dados.celula-tipo-borda-esq = 02. 
        WHEN 15 THEN
            ASSIGN tt-dados.celula-valor = c-tit-relat.
        WHEN iNumColunas THEN 
            ASSIGN tt-dados.celula-valor                  = STRING(TODAY)
                   tt-dados.celula-alinhamento-horizontal = 5
                   tt-dados.celula-tipo-borda-dir         = 02.
    END CASE.

END.

ASSIGN iLinha  = iLinha + 1.

{utp/ut-liter.i Grupo_Produtor:_ *}
ASSIGN c-lb-grp-produt = RETURN-VALUE.

{utp/ut-liter.i Produtor *}
ASSIGN c-lb-produt-rural = RETURN-VALUE.

{utp/ut-liter.i Descri‡Æo *}
ASSIGN c-lb-descricao = RETURN-VALUE.

{utp/ut-liter.i Propriedade *}
ASSIGN c-lb-propried = RETURN-VALUE.

{utp/ut-liter.i Ponto_de_Coleta *}
ASSIGN c-lb-pto-coleta = RETURN-VALUE.

{utp/ut-liter.i Qtd_Total *}
ASSIGN c-lb-qtd-total = RETURN-VALUE.

{utp/ut-liter.i Total *}
ASSIGN c-lb-total = RETURN-VALUE.

FOR EACH tt-produtor
    BREAK BY tt-produtor.cdn-grp-produt:

    IF FIRST-OF(tt-produtor.cdn-grp-produt) THEN DO:

        /* CRIA QUEBRA GRUPO PRODUTOR */
        DO iColuna = 1 TO iNumColunas:
            RUN cria-tt-dados.
            ASSIGN tt-dados.celula-tipo-borda-inf = 02
                   tt-dados.celula-tipo-borda-sup = 02.
            CASE iColuna:
                WHEN 1  THEN 
                    ASSIGN tt-dados.celula-valor  = c-lb-grp-produt + STRING(tt-produtor.cdn-grp-produt) + ' - ' +  tt-produtor.des-grp-produt.  
            END CASE.   
        END.

        ASSIGN iLinha  = iLinha + 1.

        /* CRIA CABE€ALHO PRODUTORES  */
        DO iColuna = 1 TO iNumColunas:
            RUN cria-tt-dados.
            ASSIGN tt-dados.celula-tipo-borda-inf = 02
                   tt-dados.celula-tipo-borda-sup = 02
                   tt-dados.celula-tipo-borda-esq = 02
                   tt-dados.celula-tipo-borda-dir = 02
                   tt-dados.celula-alinhamento-horizontal = 01. /* centralizado */
                   
            CASE iColuna:
                WHEN 1  THEN ASSIGN tt-dados.celula-valor  = c-lb-produt-rural.
                WHEN 2  THEN ASSIGN tt-dados.celula-valor  = c-lb-descricao.
                WHEN 3  THEN ASSIGN tt-dados.celula-valor  = c-lb-propried.
                WHEN 4  THEN ASSIGN tt-dados.celula-valor  = c-lb-pto-coleta.
                WHEN iNumColunas THEN 
                    ASSIGN tt-dados.celula-valor  = c-lb-qtd-total. 
                OTHERWISE  ASSIGN tt-dados.celula-valor  = STRING(iColuna - 4, '99') + "/":U + tt-param.period.        
            END CASE.            
        END.

        ASSIGN iLinha  = iLinha + 1.

    END.

    /* CRIA LINHAS PRODUTORES  */
    DO iColuna = 1 TO iNumColunas:
        RUN cria-tt-dados.
        ASSIGN tt-dados.celula-fonte-negrito  = NO
               tt-dados.celula-tipo-borda-inf = 02
               tt-dados.celula-tipo-borda-sup = 02
               tt-dados.celula-tipo-borda-esq = 02
               tt-dados.celula-tipo-borda-dir = 02.

        CASE iColuna:
            WHEN 1  THEN ASSIGN tt-dados.celula-valor  = STRING(tt-produtor.cdn-produt-rural).
            WHEN 2  THEN ASSIGN tt-dados.celula-valor  = tt-produtor.nome-produt.
            WHEN 3  THEN ASSIGN tt-dados.celula-valor  = tt-produtor.des-propried.
            WHEN 4  THEN ASSIGN tt-dados.celula-valor  = tt-produtor.cod-pto-coleta.
            WHEN iNumColunas THEN 
                ASSIGN tt-dados.celula-valor          = STRING(tt-produtor.total-coleta)  
                       tt-dados.celula-fonte-negrito  = YES.
            OTHERWISE DO:
                FIND FIRST tt-tot-dia WHERE tt-tot-dia.cdn-grp-produt = tt-produtor.cdn-grp-produt AND tt-tot-dia.dia = iColuna - 4 NO-ERROR.
                IF NOT AVAIL tt-tot-dia THEN DO:
                    CREATE tt-tot-dia.
                    ASSIGN tt-tot-dia.cdn-grp-produt = tt-produtor.cdn-grp-produt
                           tt-tot-dia.dia = iColuna - 4
                           tt-tot-dia.qtd = tt-produtor.coleta[iColuna - 4].
                END.
                ELSE DO:
                    ASSIGN tt-tot-dia.qtd = tt-tot-dia.qtd + tt-produtor.coleta[iColuna - 4].
                END.
     
                IF tt-produtor.coleta[iColuna - 4] > 0 THEN
                    ASSIGN tt-dados.celula-valor          = STRING(tt-produtor.coleta[iColuna - 4])
                           tt-dados.celula-fonte-negrito  = NO.
               
            END.       
        END CASE.            
    END.
    ASSIGN iLinha  = iLinha + 1.

ASSIGN iQtdGrupo = 0.

    IF LAST-OF(tt-produtor.cdn-grp-produt) THEN DO:
        DO iColuna = 1 TO iNumColunas:

            /* CRIA LINHA TOTAL GRUPO POR DIA  */
            RUN cria-tt-dados.
            ASSIGN tt-dados.celula-tipo-borda-inf = 02
                   tt-dados.celula-tipo-borda-sup = 02
                   tt-dados.celula-tipo-borda-esq = 02
                   tt-dados.celula-tipo-borda-dir = 02
                   tt-dados.celula-fonte-negrito  = YES.

            CASE iColuna:
                WHEN 1 THEN ASSIGN tt-dados.celula-valor  = c-lb-total.
                WHEN 2 OR WHEN 3 OR WHEN 4 THEN  ASSIGN tt-dados.celula-valor = "".
                WHEN iNumColunas THEN ASSIGN tt-dados.celula-valor = STRING(iQtdGrupo).
                OTHERWISE DO:
                    FOR FIRST tt-tot-dia WHERE  tt-tot-dia.cdn-grp-produt = tt-produtor.cdn-grp-produt AND tt-tot-dia.dia = iColuna - 4:
                        ASSIGN tt-dados.celula-valor = "". 
                        IF tt-tot-dia.qtd > 0 THEN DO:
                            ASSIGN tt-dados.celula-valor = STRING(tt-tot-dia.qtd)
                                   iQtdGrupo = iQtdGrupo + tt-tot-dia.qtd.
                            
                        END.
                    END.
                END.
            END CASE.

        END.

         ASSIGN iLinha  = iLinha + 1.

        /* CRIA QUEBRA DE LINHA EM BRANCO  */
        DO iColuna = 1 TO iNumColunas:
            RUN cria-tt-dados.
            ASSIGN tt-dados.celula-tipo-borda-sup = 07
                   tt-dados.celula-tipo-borda-inf = 07
                   tt-dados.celula-tipo-borda-esq = 07
                   tt-dados.celula-tipo-borda-dir = 07.
        END.
        ASSIGN iLinha  = iLinha + 1.
    END.

END.

/* CALCULA TOTAL GERAL */ 
FOR EACH tt-tot-dia:
    ASSIGN i-total = i-total + tt-tot-dia.qtd.
    FIND FIRST tt-total WHERE tt-total.dia = tt-tot-dia.dia NO-ERROR.

    IF NOT AVAIL tt-total THEN
        CREATE tt-total.

    ASSIGN tt-total.dia = tt-tot-dia.dia
           tt-total.qtd = tt-total.qtd + tt-tot-dia.qtd.
END.


/* CRIA LINHA TOTAIS GERAL  */
DO iColuna = 1 TO iNumColunas:

    RUN cria-tt-dados.
    ASSIGN tt-dados.celula-tipo-borda-inf = 02
           tt-dados.celula-tipo-borda-sup = 02
           tt-dados.celula-tipo-borda-esq = 02
           tt-dados.celula-tipo-borda-dir = 02.

    CASE iColuna:
        WHEN 1   THEN ASSIGN tt-dados.celula-valor  = c-lb-total.
        WHEN 2 OR WHEN 3 OR WHEN 4 THEN NEXT.
        WHEN iNumColunas THEN ASSIGN tt-dados.celula-valor  = STRING(i-total).
        OTHERWISE DO:
            FOR FIRST tt-total WHERE tt-total.dia = iColuna - 4 AND tt-total.qtd > 0:
                 ASSIGN tt-dados.celula-valor  = STRING(tt-total.qtd).        
            END.
        END.
    END CASE.          

END.
    
DEFINE VARIABLE i-cont-err AS INTEGER     NO-UNDO.

RUN utp/utapi013.p PERSISTENT SET h-utapi013.

RUN pi-execute2 IN h-utapi013 (INPUT-OUTPUT TABLE tt-configuracao2,
                               INPUT-OUTPUT TABLE tt-planilha2,
                               INPUT-OUTPUT TABLE tt-dados,
                               INPUT-OUTPUT TABLE tt-formatar-faixa,
                               INPUT-OUTPUT TABLE tt-grafico2,
                               INPUT-OUTPUT TABLE tt-erros).   

IF return-value = "NOK":U THEN DO:
    ASSIGN i-cont-err = 1.
    FOR EACH tt-erros: 
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = i-cont-err
               tt-erro.cd-erro  = tt-erros.cod-erro
               tt-erro.mensagem = STRING(desc-error,"x(255)").
        ASSIGN i-cont-err = i-cont-err + 1.
    END.

    FIND FIRST tt-erro NO-LOCK NO-ERROR.
    IF AVAIL tt-erro THEN DO:
       RUN cdp/cd0666.w (INPUT table tt-erro).
    END.
 END.

 DELETE PROCEDURE h-utapi013.
/*----------------GERANDO ARQUIVO*/           


RUN pi-finalizar IN h-acomp.
/* **********************  Internal Procedures  *********************** */

    
RETURN "OK":U.
