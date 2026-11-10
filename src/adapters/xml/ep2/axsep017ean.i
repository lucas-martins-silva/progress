
/*-------------------------------------------------
               AXSEP017EAN.i
-------------------------------------------------*/

PROCEDURE pi-retorna-EAN:

    DEFINE INPUT  PARAMETER pc-Item     AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-UnMed    AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-PaisOrig AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pi-Fornec   AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-EAN      AS CHARACTER   NO-UNDO.

    IF  NOT CAN-FIND(FIRST item-fornec-fabrican-umd) THEN
        RETURN.
    
    EMPTY TEMP-TABLE tt-combinacao.
    
    RUN pi-gera-tt-combinacao (INPUT pc-Item,
                               INPUT pc-UnMed,
                               INPUT pc-PaisOrig,
                               INPUT pi-Fornec).

    Busca-EAN:
    FOR EACH tt-combinacao:
    
        FOR LAST item-fornec-fabrican-umd NO-LOCK
           WHERE item-fornec-fabrican-umd.cod-item      = tt-combinacao.cod-item
             AND item-fornec-fabrican-umd.cod-un-medid  = tt-combinacao.cod-un-medid
             AND item-fornec-fabrican-umd.cod-pais-orig = tt-combinacao.cod-pais-orig
             AND item-fornec-fabrican-umd.cdn-emitente  = tt-combinacao.cdn-emitente:

            ASSIGN pc-EAN = TRIM(item-fornec-fabrican-umd.cod-ean).
        END.

        IF  pc-EAN <> "":U THEN
            LEAVE Busca-EAN.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-gera-tt-combinacao:

    DEFINE INPUT  PARAMETER pc-Item     AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-UnMed    AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-PaisOrig AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pi-Fornec   AS INTEGER     NO-UNDO.

    /*********************************************************************************************************
    Objetivo: gerar uma tabela de combinacoes possiveis para a busca do codigo GTIN/EAN para NF-e
    na tabela item-fornec-fabrican-umd. 
    Este metodo nao sofrera alteracoes se nao for criado um novo campo de busca no 
    programa CD0867 - Relacionamento Item x Un Med x Pais Origem x Fornecedor
    **********************************************************************************************************
    
    Seq   Item	Un Med	Pa¡s   Fornec
    01	  xxx	xxx	    xxx	   xxx
    02	  xxx	xxx	    xxx	    * 
    03	  xxx	xxx	     * 	   xxx
    04	  xxx	xxx	     * 	    * 
    05	  xxx	 * 	    xxx	   xxx
    06	  xxx	 * 	    xxx	    * 
    07	  xxx	 * 	     * 	   xxx
    08	  xxx	 * 	     * 	    * 
    09	   * 	xxx	    xxx	   xxx
    10	   * 	xxx	    xxx	    * 
    11	   * 	xxx	     * 	   xxx
    12	   * 	xxx	     * 	    * 
    13	   * 	 * 	    xxx	   xxx
    14	   * 	 * 	    xxx	    * 
    15	   * 	 * 	     * 	   xxx
    16	   * 	 * 	     * 	    * 
    
    **********************************************************************************************************
        
    A tabela de combinacoes possiveis ira possuir 4 campos de busca (Item, Un Med, Pa¡s Origem e Fornec). 
    Considerando essa informacao, para criacao dos registros na tabela, ao todos teremos 16 combinacoes. 
    Para cada campo duplica-se o numero de combinacoes na tabela, ou seja, um Campo = duas cobinacoes,
    dois campos = quatro combinacoes, tres campos = oito combinacoes e quatro campos = dezesseis combinacoes,
    e assim sucessivamente. Por fim, teremos 16 registros nessa tabela, que representam 16 combinacoes.
    
    *********************************************************************************************************/
    
    DEFINE VARIABLE i-cont AS INTEGER          NO-UNDO.
    DEFINE VARIABLE l-item AS LOGICAL EXTENT 2 NO-UNDO.

    ASSIGN l-item = NO.

    FIND FIRST item-fornec-fabrican-umd
         WHERE item-fornec-fabrican-umd.cod-item = pc-Item NO-LOCK NO-ERROR.
    IF  AVAIL item-fornec-fabrican-umd THEN
        ASSIGN l-item[1] = YES.
    
    FIND FIRST item-fornec-fabrican-umd
         WHERE item-fornec-fabrican-umd.cod-item = "*" NO-LOCK NO-ERROR.
    IF  AVAIL item-fornec-fabrican-umd THEN
        ASSIGN l-item[2] = YES.

    DO i-cont = 1 TO 16:
        
        IF  (    i-cont <= 8
             AND l-item[1] = YES) 
        OR  (    i-cont >= 9
             AND l-item[2] = YES) THEN DO:
            
            CREATE tt-combinacao.
            ASSIGN tt-combinacao.seq = i-cont.
            
            /* ITEM */

            /* informado */
            IF  i-cont <= 8
            AND l-item[1] = YES THEN
                ASSIGN tt-combinacao.cod-item = pc-Item.

            /* generico */
            IF  i-cont >= 9
            AND l-item[2] = YES THEN
                ASSIGN tt-combinacao.cod-item = "*".

            /* UNIDADE MEDIDA */

            /* informado */
            IF (    i-cont >= 1
                AND i-cont <= 4)
            OR (    i-cont >= 9
                AND i-cont <= 12) THEN
                ASSIGN tt-combinacao.cod-un-medid = pc-UnMed.

            /* generico */
            IF (    i-cont >= 5
                AND i-cont <= 8)
            OR (    i-cont >= 13
                AND i-cont <= 16) THEN
                ASSIGN tt-combinacao.cod-un-medid = "*".

            /* PAÖS ORIGEM */

            /*informado*/
            IF (i-cont = 1
            OR  i-cont = 2
            OR  i-cont = 5
            OR  i-cont = 6
            OR  i-cont = 9
            OR  i-cont = 10
            OR  i-cont = 13
            OR  i-cont = 14) THEN
                ASSIGN tt-combinacao.cod-pais-orig = pc-PaisOrig.

            /* generico */
            IF (i-cont = 3
            OR  i-cont = 4
            OR  i-cont = 7
            OR  i-cont = 8
            OR  i-cont = 11
            OR  i-cont = 12
            OR  i-cont = 15
            OR  i-cont = 16) THEN
                ASSIGN tt-combinacao.cod-pais-orig = "0".

            /* FORNECEDOR */

            /*informado*/
            IF (i-cont = 1
            OR  i-cont = 3
            OR  i-cont = 5
            OR  i-cont = 7
            OR  i-cont = 9
            OR  i-cont = 11
            OR  i-cont = 13
            OR  i-cont = 15) THEN
                ASSIGN tt-combinacao.cdn-emitente = pi-Fornec.

            /* generico */
            IF (i-cont = 2
            OR  i-cont = 4
            OR  i-cont = 6
            OR  i-cont = 8
            OR  i-cont = 10
            OR  i-cont = 12
            OR  i-cont = 14
            OR  i-cont = 16) THEN
                ASSIGN tt-combinacao.cdn-emitente = 0.

        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
