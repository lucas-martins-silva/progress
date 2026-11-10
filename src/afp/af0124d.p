/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0124D 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i af0124d MAF}
&ENDIF

/*******************************************************************************
**
**   Programa..:  AF0124d.P
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
{cdp/cd0666.i}
{afp/af0124.i}
def new global shared var gi-prox-prior as integer no-undo.


DEF INPUT  PARAMETER i-transacao  AS INTEGER NO-UNDO.
DEF INPUT  PARAMETER i-tipo-docto AS INTEGER NO-UNDO.
DEF INPUT  PARAMETER r-documento  AS ROWID   NO-UNDO.
DEF INPUT  PARAMETER r-tt-aprop   AS ROWID   NO-UNDO.
DEF OUTPUT PARAMETER table for tt-erro.

&IF  "{&mginv_version}" >= "2.06B" &THEN

FOR EACH tt-aed-chave :
    DELETE tt-aed-chave.
END.

FOR EACH tt-aed-chave-aux :
    DELETE tt-aed-chave-aux.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.
IF  AVAIL param-global THEN DO:
    RUN prgfin/apf/apf734za.py(INPUT i-tipo-docto,
                               INPUT r-documento,          
                               INPUT param-global.ct-format,
                               INPUT i-transacao,
                               INPUT r-tt-aprop,
                               OUTPUT TABLE tt-aed-chave-aux).

    IF  RETURN-VALUE = "nok" THEN
        RETURN "NOK".
END.

RELEASE param-global.
        

/* Temp-table auxilizar - pode trazer N apropriacoes mas api somente aceita um
   registro por vez */
assign gi-prox-prior = 10.
FOR EACH tt-aed-chave-aux NO-LOCK:

    CREATE tt-aed-chave.
    BUFFER-COPY tt-aed-chave-aux TO tt-aed-chave.
    CASE i-tipo-docto :
        
        WHEN 24 THEN DO: /* NORMAL */
            run lap/mlaapi001.p (INPUT i-tipo-docto,                          /* Tipo docto */
                                  INPUT i-transacao,                           /* Transacao 1, 2,3 */
                                  INPUT SUBSTRING(tt-aed-chave.valor[9],1,40), /* Motivo Chave Documento EMS 5*/
                                  INPUT DEC(tt-aed-chave.valor[6]),            /* Valor */
                                  INPUT int(tt-aed-chave.valor[7]),            /* moeda(i) */
                                  INPUT v_cod_usuar_corren,                    /* usuario da Transacao */
                                  INPUT tt-aed-chave.valor[8],                 /* usuario documento */
                                  INPUT tt-aed-chave.valor[5],                 /* (Lotacao) C. custo */
                                  INPUT "",                                    /* Item - branco */
                                  INPUT string(tt-aed-chave.valor[4]),         /* Conta (ct-codigo) - referencia */
                                  INPUT tt-aed-chave.valor[10],                /* Empresa */
                                  INPUT tt-aed-chave.valor[1],                 /* Estabelecimento */ 
                                  input table tt-aed-chave,         
                                  output table tt-erro).   
            
   
        END.
        /*
        WHEN 25 THEN DO: /* ANTECIPACAO */
                run lap/mlaapi001.p (INPUT i-tipo-docto,                          /* Tipo docto */
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
        
        END.

        WHEN 26 THEN DO: /* PEF */
                run lap/mlaapi001.p (INPUT i-tipo-docto,                          /* Tipo docto */
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
        END.*/
    END CASE.
    DELETE tt-aed-chave.
END.        

RETURN.
&endif
