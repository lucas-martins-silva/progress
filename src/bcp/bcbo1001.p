/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCBO1001 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcbo1001 MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: BCBO1001.p
**
**   VersÆo....: 02.00.00 - Datasul
**
**   Objetivo..: BO de Acesso a tabela Item-cli do datasul-EMS 2 para o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/***********************  General Preprocessor Definitions Beg  ******************/
&GLOBAL-DEFINE Table Item-cli
&GLOBAL-DEFINE ProductName datasul-EMS2
&GLOBAL-DEFINE LocalNumber 5 /** datasul-EMS 2 **/
/***********************  General Preprocessor Definitions End  ******************/


/********************************  Includes Beg  ********************************/
{bcp/bc8101.i}   /* Temporary Tables Definition */
{bcp/bcproxy.i1} /* Standard Tables Definition  */
/********************************  Includes End  ********************************/


/****************  CreateOutputRecord Preprocessor Definitions Beg  **************/

/****************  CreateOutputRecord Preprocessor Definitions End  **************/


/*******************  FindRecord Preprocessor Definitions Beg  *******************/
&GLOBAL-DEFINE FindKeyPhrase ~
                Where {&Table}.it-codigo    = ttParam{&table}.it-codigo-ini ~
                And   {&Table}.cod-emitente = ttParam{&Table}.cod-emitente-ini 
/*******************  FindRecord Preprocessor Definitions Beg  *******************/


/******************  ForEachRecord Preprocessor Definitions Beg  *****************/
&SCOPED-DEFINE NumRecords ~
    if  ttParam{&Table}.acess-mode = 6 then do: ~
        Assign vRec = vRec + 1. ~
        If vRec > ttParam{&Table}.num-of-rec then leave. ~
    End.
/* record-phrase = 1 */
&GLOBAL-DEFINE RecordPhrase01          YES              /* Determina que existe for each para record-phrase 1 */
&GLOBAL-DEFINE EachRecordPhrase01 ~
            If   ttParam{&Table}.it-codigo-ini = ttParam{&table}.it-codigo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.it-codigo = ttParam{&table}.it-codigo-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.it-codigo-ini <> ttParam{&table}.it-codigo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.it-codigo >= ttParam{&table}.it-codigo-ini ~
                    And   {&Table}.it-codigo <= ttParam{&table}.it-codigo-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ 

/* record-phrase = 2 */
&GLOBAL-DEFINE RecordPhrase02          YES              /* Determina que existe for each para record-phrase 2 */
&GLOBAL-DEFINE EachRecordPhrase02 ~
            If   ttParam{&Table}.nome-abrev-ini = ttParam{&Table}.nome-abrev-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.nome-abrev = ttParam{&Table}.nome-abrev-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.nome-abrev-ini <> ttParam{&Table}.nome-abrev-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.nome-abrev >= ttParam{&Table}.nome-abrev-ini ~
                    And   {&Table}.nome-abrev <= ttParam{&Table}.nome-abrev-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ 

/* record-phrase = 3 */
&GLOBAL-DEFINE RecordPhrase03          YES              /* Determina que existe for each para record-phrase 3 */
&GLOBAL-DEFINE EachRecordPhrase03 ~
            If   ttParam{&Table}.cod-emitente-ini = ttParam{&Table}.cod-emitente-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.cod-emitente = ttParam{&Table}.cod-emitente-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.cod-emitente-ini <> ttParam{&Table}.cod-emitente-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.cod-emitente >= ttParam{&Table}.cod-emitente-ini ~
                    And   {&Table}.cod-emitente <= ttParam{&Table}.cod-emitente-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */

/* record-phrase = 4 */
&GLOBAL-DEFINE RecordPhrase04          YES              /* Determina que existe for each para record-phrase 3 */
&GLOBAL-DEFINE EachRecordPhrase04 ~
                If   ttParam{&Table}.nome-abrev-ini   = ttParam{&Table}.nome-abrev-fim ~
                AND  ttParam{&Table}.it-codigo-ini    = ttParam{&table}.it-codigo-fim ~
                then do: ~
                     For Each {&Table} no-lock ~
                        Where {&Table}.nome-abrev     = ttParam{&Table}.nome-abrev-ini ~
                          AND {&Table}.it-codigo      = ttParam{&table}.it-codigo-ini: ~
                        {&NumRecords} ~
                        Run CreateOutputRecord. ~
                     End. /* Each {&Table} */ ~
                End. /* If ... do: */ ~
                If   ttParam{&Table}.nome-abrev-ini   = ttParam{&Table}.nome-abrev-fim ~
                AND  ttParam{&Table}.it-codigo-ini   <> ttParam{&table}.it-codigo-fim ~
                then do: ~
                     For Each {&Table} no-lock ~
                        Where {&Table}.nome-abrev     = ttParam{&Table}.nome-abrev-ini ~
                          AND {&Table}.it-codigo     >= ttParam{&table}.it-codigo-ini ~
                          AND {&Table}.it-codigo     <= ttParam{&table}.it-codigo-fim: ~
                        {&NumRecords} ~
                        Run CreateOutputRecord. ~
                     End. /* Each {&Table} */ ~
                End. /* If ... do: */ ~
                If   ttParam{&Table}.it-codigo-ini    = ttParam{&table}.it-codigo-fim ~
                AND ttParam{&Table}.nome-abrev-ini   <> ttParam{&Table}.nome-abrev-fim ~
                then do: ~
                     For Each {&Table} no-lock ~
                        Where {&Table}.it-codigo      = ttParam{&table}.it-codigo-ini ~
                          AND {&Table}.nome-abrev    >= ttParam{&Table}.nome-abrev-ini ~
                          AND {&Table}.nome-abrev    <= ttParam{&Table}.nome-abrev-fim: ~
                        {&NumRecords} ~
                        Run CreateOutputRecord. ~
                     End. /* Each {&Table} */ ~
                End. /* If ... do: */ ~
&GLOBAL-DEFINE RecordPhrase05          YES              /* Determina que existe for each para record-phrase 7 */
&GLOBAL-DEFINE EachRecordPhrase05 ~
            Find FIRST {&Table} no-lock ~
                 WHERE {&Table}.Nome-abrev = ttParam{&Table}.Nome-abrev-ini ~
                    no-error. ~
            Run CreateOutputRecord. 

/******************  ForEachRecord Preprocessor Definitions End  *****************/


/*********************************  Program Beg *********************************/
{bcp/bcbo.i}
/*********************************  Program End *********************************/


