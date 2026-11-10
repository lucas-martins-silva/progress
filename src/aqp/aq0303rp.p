/********************************************************************************
** Copyright TOTVS S.A. (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0303RP 2.00.00.014 } /*** "010014" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0303RP MAQ}
&ENDIF


/*******************************************************************************
**
**   Programa: AQ0303
**
**   Data....: Fevereiro de 2016
**
**   Objetivo: Exportar planilha de produtores para envio a laboratório externo
**
*******************************************************************************/


/* Parameters Definitions ---                                           **/
{aqp/aq0303.i} /*temp-tables*/
{utp/ut-glob.i}
{method/dbotterr.i} /* rowErrors*/

DEFINE VARIABLE h-acomp    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-utapi033 AS HANDLE NO-UNDO.

DEFINE VARIABLE c-lb-impr        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-dest        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-usuar       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-estabel     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-cod-layout  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-periodo     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-pto-col     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-pto-col-des AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-arq-saida   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-externo    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-propried   LIKE propried-rural.cod-propried NO-UNDO.
DEFINE VARIABLE i-ult-col        AS INTEGER   NO-UNDO.
DEFINE VARIABLE i                AS INTEGER   NO-UNDO.

{include/i-rpvar.i}

{include/tt-edit.i}

{utp/ut-liter.i Lista_de_Produtores_Exportados *}
ASSIGN c-titulo-relat = TRIM(RETURN-VALUE).

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

find first param-global no-lock no-error.

find empresa where empresa.ep-codigo = param-global.empresa-prin no-lock no-error.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

FOR EACH tt-raw-digita NO-LOCK:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

assign c-empresa   = (if avail param-global then param-global.grupo else "")
       c-programa  = "AQ0303".

{include/i-rpcab.i}

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

form tt-digita.cdn-produt-rural 
     tt-digita.nome-emit        FORMAT "X(71)":U
     tt-digita.cod-pto-coleta
     c-cod-propried
     c-cod-externo              FORMAT "X(15)":U
     WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-importadas.

{utp/ut-liter.i "Produtor"}
assign tt-digita.cdn-produt-rural:label        in frame f-importadas = trim(return-value).
{utp/ut-liter.i "Nome_Produtor"}
assign tt-digita.nome-emit:label     in frame f-importadas = trim(return-value).
{utp/ut-liter.i "Pto_Coleta"}
assign tt-digita.cod-pto-coleta:label     in frame f-importadas = trim(return-value).
{utp/ut-liter.i "Propriedade"}
assign c-cod-propried:label  in frame f-importadas = trim(return-value).
{utp/ut-liter.i "ID_Ext_Produtor"}
assign c-cod-externo:label in frame f-importadas = trim(return-value).

FOR EACH tt-digita:

    FOR FIRST produt-pto-coleta FIELDS(cod-externo cod-propried) NO-LOCK 
        WHERE produt-pto-coleta.cod-pto-coleta   = tt-digita.cod-pto-coleta
          AND produt-pto-coleta.cdn-produt-rural = tt-digita.cdn-produt-rural
          AND produt-pto-coleta.log-livre-1 /* Ativo */ :

        ASSIGN c-cod-externo  = produt-pto-coleta.cod-externo
               c-cod-propried = produt-pto-coleta.cod-propried.    
    END.

    DISP tt-digita.cdn-produt-rural
         tt-digita.nome-emit
         tt-digita.cod-pto-coleta
         c-cod-propried
         c-cod-externo         
             WITH FRAME f-importadas.
        DOWN WITH FRAME f-importadas.
   
END.



{utp/ut-liter.i IMPRESSÇO * r}
assign c-lb-impr = trim(return-value).
{utp/ut-liter.i Destino * r}
assign c-lb-dest = trim(return-value).
{utp/ut-liter.i Usu rio * r}
assign c-lb-usuar = trim(return-value).
{utp/ut-liter.i Estabelecimento * r}
assign c-lb-estabel = trim(return-value).
{utp/ut-liter.i C¢digo_layout * r}
assign c-lb-cod-layout = trim(return-value).
{utp/ut-liter.i Amostras_ponto_coletivo * r}
assign c-lb-pto-col = trim(return-value).
{utp/ut-liter.i Periodo * r}
assign c-lb-periodo = trim(return-value).
{utp/ut-liter.i Arquivo_de_sa¡da * r}
assign c-lb-arq-saida = trim(return-value).

IF tt-param.rd-amostra-pto-col = 1 THEN DO:
    {utp/ut-liter.i Por_produtor * r}
END.
ELSE DO:
    {utp/ut-liter.i énica * r}
END.
assign c-lb-pto-col-des = trim(return-value).

PUT UNFORMATTED SKIP(3)
    c-lb-impr               SKIP(1)
    c-lb-dest               AT 5  ": "  AT 28  tt-param.destino " - " tt-param.arquivo
    c-lb-usuar              AT 5  ": "  AT 28  tt-param.usuario 
    c-lb-estabel            AT 5  ": "  AT 28  tt-param.cod-estabel       
    c-lb-cod-layout         AT 5  ": "  AT 28  tt-param.cod-layout        
    c-lb-pto-col            AT 5  ": "  AT 28  c-lb-pto-col-des
    c-lb-periodo            AT 5  ": "  AT 28  SUBSTRING(tt-param.cod-period,1,2) + "/" + SUBSTRING(tt-param.cod-period,3,4) 
    c-lb-arq-saida          AT 5  ": "  AT 28  "'" tt-param.arq-saida "'"   SKIP(1).

{include/i-rpclo.i}

{include/pi-edit.i}
/*=======================================================================================*/

/*geração da planilha de produtores*/
RUN utp/utapi033.p PERSISTENT SET h-utapi033.

{utp/ut-liter.i Planilha_produtores_an lises_externas *}
ASSIGN c-titulo-relat = TRIM(RETURN-VALUE).

{utp/ut-liter.i Gerando_Planilha *}
RUN pi-inicializar IN h-acomp (INPUT TRIM(RETURN-VALUE)).


/*colunas*/
def var i-coluna as integer no-undo.

EMPTY TEMP-TABLE tt-conteudo-planilha NO-ERROR.
FOR EACH layout-restdo-analis-col NO-LOCK WHERE layout-restdo-analis-col.cod-layout = tt-param.cod-layout
                        AND (layout-restdo-analis-col.idi-tipo = 1 OR layout-restdo-analis-col.idi-tipo = 2):

    ASSIGN i-coluna = i-coluna + 1.

    CREATE tt-conteudo-planilha.
    ASSIGN tt-conteudo-planilha.i-coluna           = layout-restdo-analis-col.num-col
           tt-conteudo-planilha.i-cdn-campo-layout = layout-restdo-analis-col.cdn-campo-layout 
           tt-conteudo-planilha.des-campo          = layout-restdo-analis-col.des-coluna
           tt-conteudo-planilha.conteudo           = "".

END.


/*encontra o número da maior coluna*/
FOR LAST tt-conteudo-planilha BY i-coluna:
    ASSIGN i-ult-col = tt-conteudo-planilha.i-coluna.
END.

/*Cria colunas com cabeçalho em branco*/
DO i = 1 TO i-ult-col:
    IF NOT CAN-FIND(FIRST tt-conteudo-planilha WHERE tt-conteudo-planilha.i-coluna = i) THEN
        RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT "", INPUT "", INPUT 20 ).
END.
/*fim colunas*/


/*linhas*/
FOR EACH tt-digita:

    RUN piNewLine IN h-utapi033.

    DO i = 1 TO i-ult-col:
   
        FOR FIRST tt-conteudo-planilha WHERE tt-conteudo-planilha.i-coluna = i:
            CASE tt-conteudo-planilha.i-cdn-campo-layout:
                WHEN 1 THEN DO: /*ESTABELEC*/
                    ASSIGN tt-conteudo-planilha.conteudo = tt-param.cod-estabel.  
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 70 ).
                END.
                WHEN 2 THEN DO: /*Nome_Estabel*/
                    FOR FIRST estabelec FIELDS(nome) WHERE estabelec.cod-estabel = tt-param.cod-estabel:
                        ASSIGN tt-conteudo-planilha.conteudo = estabelec.nome.    
                    END.
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 300 ).
                END.
                WHEN 3 THEN DO: /*Fornecedor/Produtor*/
                    ASSIGN tt-conteudo-planilha.conteudo = STRING(tt-digita.cdn-produt-rural).
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).    
                END.
                WHEN 4 THEN DO: /*Nome_Fornec/Produtor*/
                    ASSIGN tt-conteudo-planilha.conteudo = tt-digita.nome-emit.
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 300 ).
                END.
                WHEN 5 THEN DO: /*Propriedade*/
                    FOR FIRST produt-pto-coleta FIELDS(cod-propried) NO-LOCK WHERE produt-pto-coleta.cod-pto-coleta = tt-digita.cod-pto-coleta
                                                                               AND produt-pto-coleta.log-livre-1 /* Ativo */:
                        ASSIGN tt-conteudo-planilha.conteudo = produt-pto-coleta.cod-propried.    
                    END.
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 150 ).                    
                END.
                WHEN 6 THEN DO: /*Nome_Propriedade*/
                    FOR FIRST produt-pto-coleta FIELDS(cod-propried) NO-LOCK WHERE produt-pto-coleta.cod-pto-coleta   = tt-digita.cod-pto-coleta
                                                                               AND produt-pto-coleta.cdn-produt-rural = tt-digita.cdn-produt-rural
                                                                               AND produt-pto-coleta.log-livre-1 /* Ativo */ :
                        FOR FIRST propried-rural FIELDS(nome-abrev) NO-LOCK WHERE propried-rural.cod-propried = produt-pto-coleta.cod-propried:
                            ASSIGN tt-conteudo-planilha.conteudo = propried-rural.nome-abrev.    
                        END.
                    END.
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 300 ).
                END.
                WHEN 7 THEN DO: /*Rota*/
                    ASSIGN tt-conteudo-planilha.conteudo = tt-digita.cod-rota.  
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).  
                END.
                WHEN 8 THEN DO: /*Descri‡Æo_Rota*/
                    FOR FIRST rota-coleta FIELDS(des-rota) NO-LOCK WHERE rota-coleta.cod-rota = tt-digita.cod-rota:
                        ASSIGN tt-conteudo-planilha.conteudo = rota-coleta.des-rota.    
                    END.
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 300 ).
                END.
                WHEN 9 THEN DO: /*Ponto_Coleta*/
                    ASSIGN tt-conteudo-planilha.conteudo = tt-digita.cod-pto-coleta.
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).
                END.
                WHEN 10 THEN DO: /*Desc_Ponto_Coleta*/
                    ASSIGN tt-conteudo-planilha.conteudo = tt-digita.des-pto-coleta.    
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 300 ).
                END.
                WHEN 15 THEN DO: /*Roteiro*/
                    ASSIGN tt-conteudo-planilha.conteudo = "".    
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).
                END.
                WHEN 16 THEN DO: /*Dep¢sito*/
                    ASSIGN tt-conteudo-planilha.conteudo = "".    
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).
                END.
                WHEN 17 THEN DO: /*Referˆncia*/
                    ASSIGN tt-conteudo-planilha.conteudo = "".    
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).
                END.
                WHEN 18 THEN DO: /*Lote/S‚rie*/
                    ASSIGN tt-conteudo-planilha.conteudo = "".    
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).
                END.
                WHEN 19 THEN DO: /*Localiza‡Æo*/
                    ASSIGN tt-conteudo-planilha.conteudo = "".    
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 150 ).
                END.
                WHEN 20 THEN DO: /*Documento*/
                    ASSIGN tt-conteudo-planilha.conteudo = "".    
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 180 ).
                END.
                WHEN 21 THEN DO: /*S‚rie_Docto*/
                    ASSIGN tt-conteudo-planilha.conteudo = "".    
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).
                END.
                WHEN 22 THEN DO: /*Nat_Opera‡Æo*/
                    ASSIGN tt-conteudo-planilha.conteudo = "".    
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).
                END.
                WHEN 23 THEN DO: /*Respons vel*/
                    ASSIGN tt-conteudo-planilha.conteudo = "".    
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).
                END.
                WHEN 28 THEN DO: /*Respons vel*/
                    FOR FIRST produt-pto-coleta FIELDS(cod-externo) NO-LOCK WHERE produt-pto-coleta.cod-pto-coleta    = tt-digita.cod-pto-coleta
                                                                               AND produt-pto-coleta.cdn-produt-rural = tt-digita.cdn-produt-rural
                                                                               AND produt-pto-coleta.log-livre-1 /* Ativo */:
                        ASSIGN tt-conteudo-planilha.conteudo = produt-pto-coleta.cod-externo. 
                    END.
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 70 ).                    
                END.
                WHEN 29 THEN DO: /*Cidade*/                    
                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).
                    
                    FOR FIRST produt-pto-coleta FIELDS(cod-propried) NO-LOCK 
                        WHERE produt-pto-coleta.cod-pto-coleta   = tt-digita.cod-pto-coleta
                          AND produt-pto-coleta.cdn-produt-rural = tt-digita.cdn-produt-rural
                          AND produt-pto-coleta.log-livre-1 /* Ativo */:
                        FOR FIRST propried-rural FIELDS(nome-abrev cod-entrega) NO-LOCK 
                            WHERE propried-rural.cod-propried = produt-pto-coleta.cod-propried:
                            FOR FIRST loc-entr FIELDS(cidade) NO-LOCK 
                                WHERE loc-entr.nome-abrev  = propried-rural.nome-abrev
                                  AND loc-entr.cod-entrega = propried-rural.cod-entrega:
                                ASSIGN tt-conteudo-planilha.conteudo = loc-entr.cidade.
                            END.
                        END.
                    END.
                    
                END.
                WHEN 30 THEN DO: /*Estado*/
                    FOR FIRST produt-pto-coleta FIELDS(cod-propried) NO-LOCK 
                        WHERE produt-pto-coleta.cod-pto-coleta   = tt-digita.cod-pto-coleta
                          AND produt-pto-coleta.cdn-produt-rural = tt-digita.cdn-produt-rural
                          AND produt-pto-coleta.log-livre-1 /* Ativo */:
                        FOR FIRST propried-rural FIELDS(nome-abrev cod-entrega) NO-LOCK 
                            WHERE propried-rural.cod-propried = produt-pto-coleta.cod-propried:
                            FOR FIRST loc-entr FIELDS(estado) NO-LOCK 
                                WHERE loc-entr.nome-abrev  = propried-rural.nome-abrev
                                  AND loc-entr.cod-entrega = propried-rural.cod-entrega:
                                ASSIGN tt-conteudo-planilha.conteudo = loc-entr.estado.
                            END.
                        END.
                    END.

                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).
                END.
                WHEN 31 THEN DO: /*C¢digo NRP*/
                    ASSIGN tt-conteudo-planilha.conteudo = "".

                    FOR FIRST produt-pto-coleta FIELDS(cod-propried) NO-LOCK
                        WHERE produt-pto-coleta.cod-pto-coleta   = tt-digita.cod-pto-coleta
                          AND produt-pto-coleta.cdn-produt-rural = tt-digita.cdn-produt-rural
                          AND produt-pto-coleta.log-livre-1 /* Ativo */:
                        FOR FIRST propried-rural FIELDS(cod-nrp) NO-LOCK
                            WHERE propried-rural.cod-propried = produt-pto-coleta.cod-propried:
                            ASSIGN tt-conteudo-planilha.conteudo = propried-rural.cod-nrp.
                        END.
                    END.

                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).
                END.
                WHEN 32 THEN DO: /*Volume Mes*/
                    ASSIGN tt-conteudo-planilha.conteudo = "".

                    FOR FIRST produt-pto-coleta FIELDS(cod-propried) NO-LOCK
                        WHERE produt-pto-coleta.cod-pto-coleta   = tt-digita.cod-pto-coleta
                          AND produt-pto-coleta.cdn-produt-rural = tt-digita.cdn-produt-rural
                          AND produt-pto-coleta.log-livre-1 /* Ativo */:
                        FOR FIRST fechto-produt-period NO-LOCK
                            WHERE fechto-produt-period.cod-period       = tt-param.cod-period
                              AND fechto-produt-period.cdn-produt-rural = tt-digita.cdn-produt-rural
                              AND fechto-produt-period.cod-propried     = produt-pto-coleta.cod-propried
                              AND fechto-produt-period.cod-estabel      = tt-param.cod-estabel:
                            ASSIGN tt-conteudo-planilha.conteudo = STRING(fechto-produt-period.qtd-period).
                        END.
                    END.

                    RUN piColumn IN h-utapi033 (INPUT i, INPUT "CHAR":U, INPUT tt-conteudo-planilha.des-campo, INPUT "", INPUT 100 ).
                END.
            END CASE.
            
        END.
    
        IF AVAIL tt-conteudo-planilha THEN
            RUN piLine IN h-utapi033 (INPUT i, INPUT tt-conteudo-planilha.conteudo).
        ELSE 
            RUN piLine IN h-utapi033 (INPUT i, INPUT ""). /*caso não encontre conteudo, cria com célula em branco*/

    END.

END.
/*fim linhas*/

/*fim geração da planilha de produtores*/

ASSIGN c-titulo-relat = c-titulo-relat + (" - ") + 
       STRING(TODAY,"99/99/9999") + " - " + STRING(TIME, "HH:MM:SS").

RUN piProcessa IN h-utapi033 (INPUT-OUTPUT tt-param.arq-saida, INPUT "AQ0303", INPUT c-titulo-relat).

IF VALID-HANDLE(h-utapi033) THEN 
  DELETE OBJECT h-utapi033.

IF  h-acomp <> ? THEN DO:
    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.    
END.

return "OK":U.
