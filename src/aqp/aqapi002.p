/********************************************************************************
** Copyright TOTVS S.A. (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQAPI002 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aqapi002 MAQ}
&ENDIF

/*****************************************************************************
**
**       Programa: AQAPI002
**
**       Objetivo: Retorno dos resultados das an lises externas
**        Cria‡Æo: 23/03/2016
**
*****************************************************************************/

{utp/ut-glob.i}
{aqp/aqapi002.i}    /* temp-tables */

/* Vari veis */
DEFINE VARIABLE l-achou AS LOGICAL     NO-UNDO.


PROCEDURE getResAnalisExtProdutor:
/*-------------------------------------------------------------------------------
  Purpose:    Retorno dos resultados das an lises externas do produtor
  
  Parameters: recebe c¢digo do produtor rural
              recebe data de in¡cio referente ao per¡odo
              recebe data de fim referente ao per¡odo
              retorna resultados das an lises (tt_retorno_analises) - aqapi002.i
              
  Notes:  Caso nÆo encontre resultados, retorna NOK e tt_retorno_analises vazia
-------------------------------------------------------------------------------*/

    DEF INPUT  PARAMETER i-cdn-produt-rural AS INTEGER NO-UNDO.
    DEF INPUT  PARAMETER c-cod-propriedade  AS CHARACTER NO-UNDO.
    DEF INPUT  PARAMETER d-data-ini         AS DATE    NO-UNDO.
    DEF INPUT  PARAMETER d-data-fim         AS DATE    NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR tt_retorno_analises.

    EMPTY TEMP-TABLE tt_produtores NO-ERROR.
    CREATE tt_produtores.
    ASSIGN tt_produtores.ttv_cdn_produt     = i-cdn-produt-rural
           tt_produtores.tta_cod_prop_rural = c-cod-propriedade.

    RUN getResAnalisExtProdutores (INPUT TABLE tt_produtores,
                                   INPUT d-data-ini,
                                   INPUT d-data-fim,
                                   OUTPUT TABLE tt_retorno_analises).

    RETURN RETURN-VALUE.

END PROCEDURE.


PROCEDURE getResAnalisExtProdutores:
/*-------------------------------------------------------------------------------
  Purpose:    Retorno dos resultados das an lises externas (Recebe lista produtores)
  
  Parameters: recebe lista de produtores rurais (tt_produtores - aqapi002.i)
              recebe data de in¡cio referente ao per¡odo
              recebe data de fim referente ao per¡odo
              retorna resultados das an lises (tt_retorno_analises - aqapi002.i) 
              
  Notes:  Caso nÆo encontre resultados, retorna NOK e tt_retorno_analises vazia
-------------------------------------------------------------------------------*/

    /* Parƒmetros */
    DEF INPUT  PARAMETER TABLE FOR tt_produtores.
    DEF INPUT  PARAMETER d-data-ini         AS DATE    NO-UNDO.
    DEF INPUT  PARAMETER d-data-fim         AS DATE    NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR tt_retorno_analises.

    EMPTY TEMP-TABLE tt_retorno_analises NO-ERROR.  
    
    FOR EACH tt_produtores NO-LOCK:

        /* An lises externas */
        FOR EACH analis-lab-period FIELDS (nr-ficha dat-analis cdn-produt-rural cod-pto-coleta cod-propried) NO-LOCK
           WHERE analis-lab-period.cdn-produt-rural = tt_produtores.ttv_cdn_produt
             AND analis-lab-period.cod-propried     = tt_produtores.tta_cod_prop_rural 
             AND analis-lab-period.dat-analis      >= d-data-ini
             AND analis-lab-period.dat-analis      <= d-data-fim:
            
            /* Resultados dos componentes */
            FOR EACH res-fic-cq FIELDS (cod-exame cod-comp dt-result resultado) NO-LOCK
               WHERE res-fic-cq.nr-ficha = analis-lab-period.nr-ficha:
                
                ASSIGN l-achou = FALSE. 
                
                /* Regras de forma‡Æo de pre‡o */
                FOR EACH regra-form-preco NO-LOCK
                   WHERE regra-form-preco.cod-exame = res-fic-cq.cod-exame
                     AND regra-form-preco.cod-comp  = res-fic-cq.cod-comp
                     AND regra-form-preco.cdn-tipo  = 2 /* Qualidade */
                     AND regra-form-preco.dat-inic  <= analis-lab-period.dat-analis 
                     AND regra-form-preco.dat-fim   >= analis-lab-period.dat-analis
                      BY regra-form-preco.cdn-abrangen DESC :        
        
                    CASE regra-form-preco.cdn-abrangen:
                        WHEN 1 /* pto-coleta */ THEN DO:
                            ASSIGN l-achou = analis-lab-period.cod-pto-coleta = regra-form-preco.cod-pto-coleta.
                        END.
                        WHEN 2 /* propriedade */ THEN DO:
                            ASSIGN l-achou = analis-lab-period.cod-propried = regra-form-preco.cod-propried.
                        END.
                        when 3 then do: /*Produtor*/
                            ASSIGN l-achou = analis-lab-period.cdn-produt-rural = regra-form-preco.cdn-produt-rural.
                        end. 
                        when 4 then do: /*Grupo*/     
                            ASSIGN l-achou = CAN-FIND(FIRST produt-rural
                                                      WHERE produt-rural.cdn-produt-rural = analis-lab-period.cdn-produt-rural
                                                        AND produt-rural.cdn-grp-produt   = regra-form-preco.cdn-grp-produt).                
                        end.
                        when 5 then do: /*Rota*/
                            FOR FIRST carg-rural FIELDS()
                                WHERE carg-rural.cod-rota  = regra-form-preco.cod-rota
                                  AND carg-rural.dat-trans >= regra-form-preco.dat-inic
                                  AND carg-rural.dat-trans <= regra-form-preco.dat-fim NO-LOCK,
                                FIRST produt-carg 
                                WHERE produt-carg.num-carg         = carg-rural.num-carg
                                  AND produt-carg.cdn-produt-rural = analis-lab-period.cdn-produt-rural NO-LOCK:
        
                                ASSIGN l-achou = TRUE.
                            END.
                        end.
                        when 6 then do: /*Regiao*/
                            ASSIGN l-achou = CAN-FIND(FIRST pto-coleta
                                                      WHERE pto-coleta.cod-pto-coleta = analis-lab-period.cod-pto-coleta
                                                        AND pto-coleta.cod-regiao     = regra-form-preco.cod-regiao).
                        end.
                        when 7 then do: /*Estabelecimento*/
                            ASSIGN l-achou = CAN-FIND(FIRST ficha-cq
                                                      WHERE ficha-cq.nr-ficha    = analis-lab-period.nr-ficha
                                                        AND ficha-cq.cod-estabel = regra-form-preco.cod-estabel).
                        end.
                        when 8 then do: /*Todos*/
                            ASSIGN l-achou = TRUE.
                        end.   
                    END CASE. 
        
                    IF l-achou THEN DO:         
                        FOR FIRST comp-exame FIELDS (descricao) NO-LOCK 
                            WHERE comp-exame.cod-exame = res-fic-cq.cod-exame
                              AND comp-exame.cod-comp  = res-fic-cq.cod-comp: 
        
                            CREATE tt_retorno_analises.
                            ASSIGN tt_retorno_analises.ttv_num_ficha      = analis-lab-period.nr-ficha
                                   tt_retorno_analises.ttv_cdn_exam       = res-fic-cq.cod-exame
                                   tt_retorno_analises.ttv_cdn_compon     = res-fic-cq.cod-comp
                                   tt_retorno_analises.ttv_dat_restdo     = res-fic-cq.dt-result
                                   tt_retorno_analises.ttv_des_compon     = comp-exame.descricao
                                   tt_retorno_analises.ttv_val_restdo     = res-fic-cq.resultado
                                   tt_retorno_analises.ttv_cdn_produt     = analis-lab-period.cdn-produt-rural
                                   tt_retorno_analises.tta_cod_prop_rural = analis-lab-period.cod-propried.
                        END.
                        LEAVE.
                    END.
                END. /* regra-form-preco */
            END. /* res-fic-cq */                                                                       
        END. /* analis-lab-period */  
    END. /* tt_produtores */

    IF NOT CAN-FIND(FIRST tt_retorno_analises) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.
