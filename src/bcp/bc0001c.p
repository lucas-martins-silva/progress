/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0001C 2.00.00.013} /*** "010013" 09/10/2025 11:26:27 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0001c MBC}
&ENDIF



/*
** 2D - cria informa‡äes padräes para layout de registros
*/
{cdp/cdcfgint.i} /* versao de produto */


DEF VAR h-table  AS HANDLE NO-UNDO.
DEF VAR h-query  AS HANDLE NO-UNDO.
DEF VAR h-field  AS HANDLE NO-UNDO.
DEF VAR i-field  AS INT    NO-UNDO.
DEF VAR i-extent AS INT    NO-UNDO.

find first param-bc
     no-lock no-error.

RUN cria-tipos-layout.
RUN cria-layouts-padroes.

/*
** 2D - cria o layout padrÆo para documento de entrada e saida 
**      cria no padrao AIM Brasil
*/
PROCEDURE cria-layouts-padroes:
    DEF VAR v-segmento      AS INTEGER NO-UNDO.

    /********* LAYOUT PADROES DATASUL - PRODUTO DATASUL EMS ***********/

    /* nota fiscal de ENTRADA 1 SEPARADOR */

    RUN bcp/bc0001c1.p (INPUT THIS-PROCEDURE,1).

    /* nota fiscal de SAIDA   2 AIM       */

    RUN bcp/bc0001c2.p (INPUT THIS-PROCEDURE,2).

    /* nota fiscal de SAIDA   3 SEPARADOR */

    RUN bcp/bc0001c3.p (INPUT THIS-PROCEDURE,3).


END PROCEDURE.

PROCEDURE cria-bc-layout:
DEFINE INPUT PARAM c-tipo-tabela AS CHARACTER NO-UNDO.
DEFINE INPUT PARAM P-cod-layout AS integer NO-UNDO.
DEFINE INPUT PARAM P-descricao AS character NO-UNDO.
DEFINE INPUT PARAM P-num-versao AS integer NO-UNDO.
DEFINE INPUT PARAM P-log-datasul AS logical NO-UNDO.
DEFINE INPUT PARAM P-cod-tipo-layout AS integer NO-UNDO.
DEFINE INPUT PARAM P-char-1 AS character NO-UNDO.
DEFINE INPUT PARAM P-char-2 AS character NO-UNDO.
DEFINE INPUT PARAM P-dec-1 AS decimal NO-UNDO.
DEFINE INPUT PARAM P-dec-2 AS decimal NO-UNDO.
DEFINE INPUT PARAM P-int-1 AS integer NO-UNDO.
DEFINE INPUT PARAM P-int-2 AS integer NO-UNDO.
DEFINE INPUT PARAM P-log-1 AS logical NO-UNDO.
DEFINE INPUT PARAM P-log-2 AS logical NO-UNDO.
DEFINE INPUT PARAM P-data-1 AS date NO-UNDO.
DEFINE INPUT PARAM P-data-2 AS date NO-UNDO.
DEFINE INPUT PARAM P-check-sum AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-1 AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-2 AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-3 AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-4 AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-5 AS character NO-UNDO.
DEFINE INPUT PARAM P-ind-leitura-campo AS integer NO-UNDO.
DEFINE INPUT PARAM P-separador-campos AS character NO-UNDO.

    FIND bc-layout EXCLUSIVE-LOCK
        WHERE bc-layout.cod-layout  = p-cod-layout
          AND bc-layout.log-datasul = YES
          AND bc-layout.num-versao  = 1
        NO-ERROR.

    IF  NOT AVAIL bc-layout THEN DO:

        CREATE bc-layout.

    END.

    ASSIGN 
            bc-layout.cod-layout =  P-cod-layout
            bc-layout.descricao =  P-descricao
            bc-layout.num-versao =  P-num-versao
            bc-layout.log-datasul =  P-log-datasul
            bc-layout.cod-tipo-layout =  P-cod-tipo-layout
            bc-layout.char-1 =  P-char-1
            bc-layout.char-2 =  P-char-2
            bc-layout.dec-1 =  P-dec-1
            bc-layout.dec-2 =  P-dec-2
            bc-layout.int-1 =  P-int-1
            bc-layout.int-2 =  P-int-2
            bc-layout.log-1 =  P-log-1
            bc-layout.log-2 =  P-log-2
            bc-layout.data-1 =  P-data-1
            bc-layout.data-2 =  P-data-2
            bc-layout.check-sum =  P-check-sum

            &IF  '{&mgcld_version}' > '2.04' 
            &THEN
            bc-layout.separador-linhas  =  P-cod-aux-1
            &ELSE
            bc-layout.cod-aux[1]       =  P-cod-aux-1
            &ENDIF

            bc-layout.cod-aux[2]  =  P-cod-aux-2
            bc-layout.cod-aux[3]  =  P-cod-aux-3
            bc-layout.cod-aux[4]  =  P-cod-aux-4
            bc-layout.cod-aux[5]  =  P-cod-aux-5
            bc-layout.ind-leitura-campo =  P-ind-leitura-campo
            bc-layout.separador-campos =  P-separador-campos.

    run utp/ut-liter.p (bc-layout.descricao,"*","R").

    ASSIGN bc-layout.descricao         = trim(return-value).

    FOR EACH bc-layout-registro EXCLUSIVE-LOCK
        WHERE bc-layout-registro.cod-layout    = bc-layout.cod-layout
          AND bc-layout-registro.log-datasul   = bc-layout.log-datasul
          AND bc-layout-registro.num-versao    = bc-layout.num-versao:

        FOR EACH bc-layout-registro-item 
            WHERE bc-layout-registro-item.num-layout-registro = bc-layout-registro.num-layout-registro 
            EXCLUSIVE-LOCK:
            DELETE bc-layout-registro-item.
        END.

        DELETE bc-layout-registro.

    END.


END.

PROCEDURE cria-bc-layout-registro:

DEFINE INPUT PARAM c-tipo-tabela AS CHARACTER NO-UNDO.
DEFINE INPUT PARAM P-cod-layout AS integer NO-UNDO.
DEFINE INPUT PARAM P-log-datasul AS logical NO-UNDO.
DEFINE INPUT PARAM P-num-versao AS integer NO-UNDO.
DEFINE INPUT PARAM P-sequencia AS integer NO-UNDO.
DEFINE OUTPUT PARAM P-num-layout-registro AS integer NO-UNDO.
DEFINE INPUT PARAM P-cod-tipo-layout-registro AS integer NO-UNDO.
DEFINE INPUT PARAM P-char-1 AS character NO-UNDO.
DEFINE INPUT PARAM P-char-2 AS character NO-UNDO.
DEFINE INPUT PARAM P-dec-1 AS decimal NO-UNDO.
DEFINE INPUT PARAM P-dec-2 AS decimal NO-UNDO.
DEFINE INPUT PARAM P-int-1 AS integer NO-UNDO.
DEFINE INPUT PARAM P-int-2 AS integer NO-UNDO.
DEFINE INPUT PARAM P-log-1 AS logical NO-UNDO.
DEFINE INPUT PARAM P-log-2 AS logical NO-UNDO.
DEFINE INPUT PARAM P-data-1 AS date NO-UNDO.
DEFINE INPUT PARAM P-data-2 AS date NO-UNDO.
DEFINE INPUT PARAM P-check-sum AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-1 AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-2 AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-3 AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-4 AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-5 AS character NO-UNDO.
DEFINE INPUT PARAM P-ind-ocorrencia AS integer NO-UNDO.

    FIND LAST bc-layout-registro USE-INDEX ch-numero NO-LOCK NO-ERROR.

    IF  AVAIL bc-layout-registro THEN
        P-num-layout-registro = bc-layout-registro.num-layout-registro + 1.
    ELSE
        P-num-layout-registro = 1.


    CREATE  bc-layout-registro.
    ASSIGN 
            bc-layout-registro.cod-layout =  P-cod-layout
            bc-layout-registro.log-datasul =  P-log-datasul
            bc-layout-registro.num-versao =  P-num-versao
            bc-layout-registro.sequencia =  p-sequencia
            bc-layout-registro.num-layout-registro =  P-num-layout-registro
            bc-layout-registro.cod-tipo-layout-registro =  P-cod-tipo-layout-registro

            &IF  '{&mgcld_version}' > '2.04' 
            &THEN
            bc-layout-registro.indicador-ini =  P-char-1
            bc-layout-registro.indicador-fim =  P-char-2
            &ELSE
            bc-layout-registro.char-1        =  P-char-1
            bc-layout-registro.char-2        =  P-char-2
            &ENDIF

            bc-layout-registro.dec-1 =  P-dec-1
            bc-layout-registro.dec-2 =  P-dec-2
            bc-layout-registro.int-1 =  P-int-1
            bc-layout-registro.int-2 =  P-int-2
            bc-layout-registro.log-1 =  P-log-1
            bc-layout-registro.log-2 =  P-log-2
            bc-layout-registro.data-1 =  P-data-1
            bc-layout-registro.data-2 =  P-data-2
            bc-layout-registro.check-sum =  P-check-sum
            &IF  '{&mgcld_version}' > '2.04' 
            &THEN
            bc-layout-registro.definicao-funcao  =  P-cod-aux-1 + P-cod-aux-2 + P-cod-aux-3 + P-cod-aux-4 + P-cod-aux-5            
            &ELSE
            bc-layout-registro.cod-aux[1]  =  P-cod-aux-1
            bc-layout-registro.cod-aux[2]  =  P-cod-aux-2
            bc-layout-registro.cod-aux[3]  =  P-cod-aux-3
            bc-layout-registro.cod-aux[4]  =  P-cod-aux-4
            bc-layout-registro.cod-aux[5]  =  P-cod-aux-5
            &ENDIF
            bc-layout-registro.ind-ocorrencia =  P-ind-ocorrencia.

    FOR EACH bc-layout-registro-item 
        WHERE bc-layout-registro-item.num-layout-registro = bc-layout-registro.num-layout-registro 
        EXCLUSIVE-LOCK:
        DELETE bc-layout-registro-item.
    END.

END PROCEDURE.


PROCEDURE cria-bc-layout-registro-item:

DEFINE INPUT PARAM c-tipo-tabela AS CHARACTER NO-UNDO.
DEFINE INPUT PARAM P-num-layout-registro AS integer NO-UNDO.
DEFINE INPUT PARAM P-sequencia AS integer NO-UNDO.
DEFINE INPUT PARAM P-tipo-item AS integer NO-UNDO.
DEFINE INPUT PARAM P-valor-item AS character NO-UNDO.
DEFINE INPUT PARAM P-tipo-dado AS character NO-UNDO.
DEFINE INPUT PARAM P-formato AS character NO-UNDO.
DEFINE INPUT PARAM P-pos-inicial AS integer NO-UNDO.
DEFINE INPUT PARAM P-num-decimais AS integer NO-UNDO.
DEFINE INPUT PARAM P-id-inicial AS character NO-UNDO.
DEFINE INPUT PARAM P-id-final AS character NO-UNDO.
DEFINE INPUT PARAM P-char-1 AS character NO-UNDO.
DEFINE INPUT PARAM P-char-2 AS character NO-UNDO.
DEFINE INPUT PARAM P-dec-1 AS decimal NO-UNDO.
DEFINE INPUT PARAM P-dec-2 AS decimal NO-UNDO.
DEFINE INPUT PARAM P-int-1 AS integer NO-UNDO.
DEFINE INPUT PARAM P-int-2 AS integer NO-UNDO.
DEFINE INPUT PARAM P-log-1 AS logical NO-UNDO.
DEFINE INPUT PARAM P-log-2 AS logical NO-UNDO.
DEFINE INPUT PARAM P-data-1 AS date NO-UNDO.
DEFINE INPUT PARAM P-data-2 AS date NO-UNDO.
DEFINE INPUT PARAM P-check-sum AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-1 AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-2 AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-3 AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-4 AS character NO-UNDO.
DEFINE INPUT PARAM P-cod-aux-5 AS character NO-UNDO.

    CREATE  bc-layout-registro-item.

    ASSIGN
            bc-layout-registro-item.num-layout-registro =  P-num-layout-registro
            bc-layout-registro-item.sequencia =  P-sequencia
            bc-layout-registro-item.tipo-item =  P-tipo-item
            bc-layout-registro-item.valor-item =  P-valor-item
            bc-layout-registro-item.tipo-dado =  P-tipo-dado
            bc-layout-registro-item.formato =  P-formato
            bc-layout-registro-item.pos-inicial =  P-pos-inicial
            bc-layout-registro-item.num-decimais =  P-num-decimais
            bc-layout-registro-item.id-inicial =  P-id-inicial
            bc-layout-registro-item.id-final =  P-id-final

            &IF  '{&mgcld_version}' > '2.04' 
            &THEN
            bc-layout-registro-item.descricao   =  P-char-1
            bc-layout-registro-item.valor-campo =  P-char-2
            &ELSE
            bc-layout-registro-item.char-1      =  P-char-1
            bc-layout-registro-item.char-2      =  P-char-2
            &ENDIF

            bc-layout-registro-item.char-2 =  P-char-2
            bc-layout-registro-item.dec-1 =  P-dec-1
            bc-layout-registro-item.dec-2 =  P-dec-2
            bc-layout-registro-item.int-1 =  P-int-1
            bc-layout-registro-item.int-2 =  P-int-2
            bc-layout-registro-item.log-1 =  P-log-1
            bc-layout-registro-item.log-2 =  P-log-2            
            bc-layout-registro-item.data-1 =  P-data-1
            bc-layout-registro-item.data-2 =  P-data-2
            bc-layout-registro-item.check-sum =  P-check-sum

            &IF  '{&mgcld_version}' > '2.04'
            &THEN

            bc-layout-registro-item.definicao-funcao = P-cod-aux-1 + P-cod-aux-2 + P-cod-aux-3 + P-cod-aux-4 + P-cod-aux-5

            &ELSE
            bc-layout-registro-item.cod-aux[1]  =  P-cod-aux-1
            bc-layout-registro-item.cod-aux[2]  =  P-cod-aux-2
            bc-layout-registro-item.cod-aux[3]  =  P-cod-aux-3
            bc-layout-registro-item.cod-aux[4]  =  P-cod-aux-4
            bc-layout-registro-item.cod-aux[5]  =  P-cod-aux-5
            &ENDIF .

END PROCEDURE.

/*
**  2D - Inicializa‡Æo do tipo de layout.
**     Tabelas: bc-tipo-layout, bc-tipo-layout-registro e bc-tipo-layout-tabela
*/

PROCEDURE cria-tipos-layout:
    RUN cria-layout-1. /* nota fiscal de saida */
    RUN cria-layout-2. /* documento de entrada */
    RUN cria-layout-3. /* estrutura bc-etiqueta */
END.

/* 
**  Layout 1 - Nota fiscal de saida 
*/
PROCEDURE cria-layout-1:
def var c-banco-1 as char.
def var c-banco-2 as char.

    FIND bc-tipo-layout 
        WHERE bc-tipo-layout.cod-tipo-layout = 1 
        EXCLUSIVE-LOCK NO-ERROR.

    IF  NOT AVAIL bc-tipo-layout THEN DO:
        CREATE bc-tipo-layout.
        ASSIGN bc-tipo-layout.cod-tipo-layout = 1.
    END.

    ASSIGN bc-tipo-layout.descricao = "Documento de Sa¡da":U.

    RUN del-layout-filhos (1).

    /* cabe‡alho */

    &if '{&mgcld_version}' <= '2.04' &then
        if  param-bc.int-2 <= 1 /* ems */
    &else
        if  param-bc.ind-sistema <= 1 /* ems */
    &endif
    then do:     
        RUN cria-layout-registro (1, 1, "Documento Sa¡da Cabe‡alho":U, 1).
        RUN cria-layout-tabela (1, 1, "movdis":U, "nota-fiscal":U).
        RUN cria-layout-tabela (1, 1, "mgadm":U, "emitente":U).
        RUN cria-layout-tabela (1, 1, "mgind":U, "natur-oper":U).
        RUN cria-layout-tabela (1, 1, "mgadm":U, "estabelec":U).
        RUN cria-layout-tabela (1, 1, "mgadm":U, "transporte":U).

        RUN cria-layout-registro (1, 2, "Documento Sa¡da Itens":U, 2).
        RUN cria-layout-tabela (1, 2, "movdis":U, "it-nota-fisc":U).
        RUN cria-layout-tabela (1, 2, "movdis":U, "nota-fiscal":U).
        RUN cria-layout-tabela (1, 2, "movdis":U, "nar-it-nota":U).
        RUN cria-layout-tabela (1, 2, "movdis":U, "fat-ser-lote":U).
        RUN cria-layout-tabela (1, 2, "mgind":U, "item":U).
        RUN cria-layout-tabela (1, 2, "mgdis":U, "item-cli":U).
        RUN cria-layout-tabela (1, 2, "mgind":U, "natur-oper":U).
        RUN cria-layout-tabela (1, 2, "mgadm":U, "emitente":U).

        RUN cria-layout-registro (1, 3, "Documento Sa¡da Duplicatas":U, 2).
        RUN cria-layout-tabela (1, 3, "movdis":U, "fat-duplic":U).
        RUN cria-layout-tabela (1, 3, "movdis":U, "nota-fiscal":U).
        RUN cria-layout-tabela (1, 3, "mgadm":U, "emitente":U).

        RUN cria-layout-registro (1, 4, "Documento Sa¡da Imposto Duplic":U, 2).
        RUN cria-layout-tabela (1, 4, "movdis":U, "fat-duplic":U).
        RUN cria-layout-tabela (1, 4, "movdis":U, "nota-fiscal":U).
        RUN cria-layout-tabela (1, 4, "mgadm":U, "emitente":U).

        RUN cria-layout-registro (1, 9, "Documento Sa¡da Rodap‚":U, 1).
        RUN cria-layout-tabela (1, 9, "movdis":U, "nota-fiscal":U).
        RUN cria-layout-tabela (1, 9, "mgadm":U, "emitente":U).
    end.
    else do:

        assign c-banco-1 = (if  CONNECTED("movcom":U)
                            and ldbname("movcom":U) = "movcom":U  /* verifica se nao e alias */
                            then "movcom":U
                            else "mgcom":U)
               c-banco-2 = (if  CONNECTED("movind":U)
                            and LDBNAME("movind":U) = "movind":U  /* verifica se nao e alias */
                            then "movind":U
                            else "mgind":U).

        RUN cria-layout-registro (1, 1, "Documento Sa¡da Cabe‡alho":U, 1).
        RUN cria-layout-tabela (1, 1, c-banco-1, "nota-fiscal":U).
        RUN cria-layout-tabela (1, 1, "mgadm":U, "emitente":U).
        RUN cria-layout-tabela (1, 1, "mgind":U, "natur-oper":U).
        RUN cria-layout-tabela (1, 1, "mgadm":U, "estabelec":U).
        RUN cria-layout-tabela (1, 1, "mgadm":U, "transporte":U).

        RUN cria-layout-registro (1, 2, "Documento Sa¡da Itens":U, 2).
        RUN cria-layout-tabela (1, 2, c-banco-1, "nota-fiscal":U).
        RUN cria-layout-tabela (1, 2, c-banco-1, "it-nota-fisc":U).
        RUN cria-layout-tabela (1, 2, c-banco-1, "nar-it-nota":U).
        RUN cria-layout-tabela (1, 2, "mgdis":U, "item-cli":U).
        RUN cria-layout-tabela (1, 2, c-banco-1, "fat-ser-lote":U).
        RUN cria-layout-tabela (1, 2, "mgind":U, "item":U).
        RUN cria-layout-tabela (1, 2, "mgind":U, "natur-oper":U).
        RUN cria-layout-tabela (1, 2, "mgadm":U, "emitente":U).

        RUN cria-layout-registro (1, 3, "Documento Sa¡da Duplicatas":U, 2).
        RUN cria-layout-tabela (1, 3, c-banco-1, "fat-duplic":U).
        RUN cria-layout-tabela (1, 3, c-banco-1, "nota-fiscal":U).
        RUN cria-layout-tabela (1, 3, "mgadm":U, "emitente":U).

        RUN cria-layout-registro (1, 4, "Documento Sa¡da Imposto Duplic":U, 2).
        RUN cria-layout-tabela (1, 4, c-banco-1, "fat-duplic":U).
        RUN cria-layout-tabela (1, 4, c-banco-1, "nota-fiscal":U).
        RUN cria-layout-tabela (1, 4, "mgadm":U, "emitente":U).

        RUN cria-layout-registro (1, 9, "Documento Sa¡da Rodap‚":U, 1).
        RUN cria-layout-tabela (1, 9, c-banco-1, "nota-fiscal":U).
        RUN cria-layout-tabela (1, 9, "mgadm":U, "emitente":U).        
    end. 

END PROCEDURE.

/* 
**  Layout 2 - documento de entrada 
*/
PROCEDURE cria-layout-2:
def var c-banco-1 as char.
def var c-banco-2 as char.

    FIND bc-tipo-layout 
        WHERE bc-tipo-layout.cod-tipo-layout = 2
        EXCLUSIVE-LOCK NO-ERROR.
    IF  NOT AVAIL bc-tipo-layout THEN DO:
        CREATE bc-tipo-layout.
        ASSIGN bc-tipo-layout.cod-tipo-layout = 2.
    END.

    ASSIGN bc-tipo-layout.descricao = "Documento de Entrada":U.

    RUN del-layout-filhos(2).

    &if '{&mgcld_version}' <= '2.04' &then
        if  param-bc.int-2 <= 1 /* ems */
    &else
        if  param-bc.ind-sistema <= 1 /* ems */
    &endif
    then do:     

        RUN cria-layout-registro (2, 1, "Documento Entrada Cabe‡alho":U, 1).
        RUN cria-layout-tabela (2, 1, "movind":U, "docum-est":U).

        RUN cria-layout-registro (2, 2, "Documento Entrada Itens":U, 2).
        RUN cria-layout-tabela (2, 2, "movind":U, "item-doc-est":U).        

        RUN cria-layout-registro (2, 3, "Documento Entrada Duplicatas":U, 2).
        RUN cria-layout-tabela (2, 3, "movind":U, "dupli-apagar":U).

        RUN cria-layout-registro (2, 4, "Documento Entrada Imposto Dupl":U, 2).
        RUN cria-layout-tabela (2, 4, "movind":U, "dupli-imp":U).

        RUN cria-layout-registro (2, 9, "Documento Entrada Rodap‚":U, 1).
        RUN cria-layout-tabela (2, 9, "movind":U, "docum-est":U).        

    end.
    else do:
        assign c-banco-1 = (if  CONNECTED("movcom":U)
                            and LDBNAME("movcom":U) = "movcom":U  /* verifica se nao e alias */
                            then "movcom":U
                            else "mgcom":U)

               c-banco-2 = (if  CONNECTED("movind":U)
                            and ldbname("movind":U) = "movind":U  /* verifica se nao e alias */
                            then "movind":U
                            else "mgind":U).

        RUN cria-layout-registro (2, 1, "Documento Entrada Cabe‡alho":U, 1).
        RUN cria-layout-tabela (2, 1, c-banco-2, "docum-est":U).

        RUN cria-layout-registro (2, 2, "Documento Entrada Itens":U, 2).
        RUN cria-layout-tabela (2, 2, c-banco-2, "item-doc-est":U).

        RUN cria-layout-registro (2, 3, "Documento Entrada Duplicatas":U, 2).
        RUN cria-layout-tabela (2, 3, c-banco-2, "dupli-apagar":U).

        RUN cria-layout-registro (2, 4, "Documento Entrada Imposto Dupl":U, 2).
        RUN cria-layout-tabela (2, 4, c-banco-2, "dupli-imp":U).

        RUN cria-layout-registro (2, 9, "Documento Entrada Rodap‚":U, 1).
        RUN cria-layout-tabela (2, 9, c-banco-2, "docum-est":U).

    end. 

END PROCEDURE.

PROCEDURE cria-layout-registro:
    DEF INPUT PARAM p-lay   AS INTEGER      NO-UNDO.
    DEF INPUT PARAM p-reg   AS INTEGER      NO-UNDO.
    DEF INPUT PARAM p-desc  AS CHARACTER    NO-UNDO.
    DEF INPUT PARAM p-ocor  AS INTEGER      NO-UNDO.

    CREATE bc-tipo-layout-registro.

    run utp/ut-liter.p (input p-desc, "*":U, "R":U).

    ASSIGN bc-tipo-layout-registro.cod-tipo-layout = p-lay
           bc-tipo-layout-registro.cod-tipo-layout-registro = p-reg
           bc-tipo-layout-registro.descricao = TRIM(RETURN-VALUE)
           bc-tipo-layout-registro.ind-ocorrencia = p-ocor.
END.

PROCEDURE cria-layout-tabela:
    DEF INPUT PARAM p-lay   AS INTEGER      NO-UNDO.
    DEF INPUT PARAM p-reg   AS INTEGER      NO-UNDO.
    DEF INPUT PARAM p-db    AS CHARACTER    NO-UNDO.
    DEF INPUT PARAM p-tab   AS CHARACTER    NO-UNDO.

    CREATE bc-tipo-layout-tabela.
    ASSIGN bc-tipo-layout-tabela.cod-tipo-layout = p-lay
           bc-tipo-layout-tabela.cod-tipo-layout-registro = p-reg
           bc-tipo-layout-tabela.cod-tabela = p-tab
           bc-tipo-layout-tabela.banco-dados = p-db.
END PROCEDURE.

PROCEDURE del-layout-filhos:
    DEF INPUT PARAM p-tipo-layout       AS INTEGER NO-UNDO.

    FOR EACH bc-tipo-layout-registro EXCLUSIVE-LOCK
        WHERE bc-tipo-layout-registro.cod-tipo-layout = p-tipo-layout:
        DELETE bc-tipo-layout-registro.
    END
        .
    FOR EACH bc-tipo-layout-tabela EXCLUSIVE-LOCK
        WHERE bc-tipo-layout-tabela.cod-tipo-layout = p-tipo-layout:
        DELETE bc-tipo-layout-tabela.
    END.
END.

PROCEDURE cria-layout-3:
def var c-banco-1 as char.
def var c-banco-2 as char.

    FIND bc-tipo-layout 
        WHERE bc-tipo-layout.cod-tipo-layout = 3
        EXCLUSIVE-LOCK NO-ERROR.

    IF  NOT AVAIL bc-tipo-layout THEN DO:
        CREATE bc-tipo-layout.
        ASSIGN bc-tipo-layout.cod-tipo-layout = 3.
    END.
    ASSIGN bc-tipo-layout.descricao = "Controle Etiqueta":U.

    RUN del-layout-filhos(3).

    RUN cria-layout-registro (3, 1, "Estrutura Etiqueta":U, 1).
    RUN cria-layout-tabela (3, 1, "mgcld":U, "bc-etiqueta":U).

END PROCEDURE.

/* fim */
