/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCBO1002 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcbo1002 MBC}
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
**   Programa..: BCBO1002.p
**
**   VersÆo....: 02.00.00 - Datasul
**
**   Objetivo..: BO de Acesso a tabela conta-contab do datasul-Ems 2 para o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/***********************  General Preprocessor Definitions Beg  ******************/
&GLOBAL-DEFINE Table conta-contab
&GLOBAL-DEFINE ProductName datasul-EMS2
&GLOBAL-DEFINE LocalNumber 3 /** datasul-Ems 2 **/
/***********************  General Preprocessor Definitions End  ******************/


/********************************  Includes Beg  ********************************/
{bcp/bc8102.i}   /* Temporary Tables Definition */
{bcp/bcproxy.i1} /* Standard Tables Definition  */
/********************************  Includes End  ********************************/


/****************  CreateOutputRecord Preprocessor Definitions Beg  **************/

/****************  CreateOutputRecord Preprocessor Definitions End  **************/


/*******************  FindRecord Preprocessor Definitions Beg  *******************/
&GLOBAL-DEFINE FindKeyPhrase ~
                Where {&Table}.ep-codigo    = ttParam{&Table}.ep-codigo-ini ~
                And   {&Table}.ct-codigo    = ttParam{&Table}.ct-codigo-ini ~
                And   {&Table}.sc-codigo    = ttParam{&Table}.sc-codigo-ini 
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
            If   ttParam{&Table}.ep-codigo-ini = ttParam{&Table}.ep-codigo-fim AND ~
                 ttParam{&Table}.ct-codigo-ini = ttParam{&Table}.ct-codigo-fim AND ~
                 ttParam{&Table}.sc-codigo-ini = ttParam{&Table}.sc-codigo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.ep-codigo = ttParam{&Table}.ep-codigo-ini ~
                    And   {&Table}.ct-codigo = ttParam{&Table}.ct-codigo-ini ~
                    And   {&Table}.sc-codigo = ttParam{&Table}.sc-codigo-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.ep-codigo-ini <> ttParam{&Table}.ep-codigo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.ep-codigo >= ttParam{&Table}.ep-codigo-ini ~
                    And   {&Table}.ct-codigo >= ttParam{&Table}.ct-codigo-ini ~
                    And   {&Table}.sc-codigo >= ttParam{&Table}.sc-codigo-ini ~
                    And   {&Table}.ep-codigo <= ttParam{&Table}.ep-codigo-fim ~
                    And   {&Table}.ct-codigo <= ttParam{&Table}.ct-codigo-fim ~
                    And   {&Table}.sc-codigo <= ttParam{&Table}.sc-codigo-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */
/* record-phrase = 2 */
&GLOBAL-DEFINE RecordPhrase02          YES              /* Determina que existe for each para record-phrase 2 */
&GLOBAL-DEFINE EachRecordPhrase02 ~
            If   ttParam{&Table}.conta-contabil-ini = ttParam{&Table}.conta-contabil-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.conta-contabil = ttParam{&Table}.conta-contabil-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.conta-contabil-ini <> ttParam{&Table}.conta-contabil-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.conta-contabil >= ttParam{&Table}.conta-contabil-ini ~
                    And   {&Table}.conta-contabil <= ttParam{&Table}.conta-contabil-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ 

/* record-phrase = 3 */
&GLOBAL-DEFINE RecordPhrase03          YES              /* Determina que existe for each para record-phrase 3 */
&GLOBAL-DEFINE EachRecordPhrase03 ~
            If   ttParam{&Table}.tipo-ini = ttParam{&Table}.tipo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.tipo = ttParam{&Table}.tipo-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.tipo-ini <> ttParam{&Table}.tipo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.tipo >= ttParam{&Table}.tipo-ini ~
                    And   {&Table}.tipo <= ttParam{&Table}.tipo-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */

/* record-phrase = 4 */
&GLOBAL-DEFINE RecordPhrase04          YES              /* Determina que existe for each para record-phrase 4 */
&GLOBAL-DEFINE EachRecordPhrase04 ~
            If   ttParam{&Table}.estado-ini = ttParam{&Table}.estado-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.estado = ttParam{&Table}.estado-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.estado-ini <> ttParam{&Table}.estado-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.estado >= ttParam{&Table}.estado-ini ~
                    And   {&Table}.estado <= ttParam{&Table}.estado-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */

/* record-phrase = 5 */
&GLOBAL-DEFINE RecordPhrase05          YES              /* Determina que existe for each para record-phrase 5 */
&GLOBAL-DEFINE EachRecordPhrase05 ~
            If   ttParam{&Table}.estado-ini = ttParam{&Table}.estado-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.estado = ttParam{&Table}.estado-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.estado-ini <> ttParam{&Table}.estado-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.estado >= ttParam{&Table}.estado-ini ~
                    And   {&Table}.estado <= ttParam{&Table}.estado-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */

/* record-phrase = 6 */
&GLOBAL-DEFINE RecordPhrase06          YES              /* Determina que existe for each para record-phrase 6 */
&GLOBAL-DEFINE EachRecordPhrase06 ~
            If   ttParam{&Table}.estoque-ini = ttParam{&Table}.estoque-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.estoque = ttParam{&Table}.estoque-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.estoque-ini <> ttParam{&Table}.estoque-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.estoque >= ttParam{&Table}.estoque-ini ~
                    And   {&Table}.estoque <= ttParam{&Table}.estoque-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */

/* record-phrase = 7 */
&GLOBAL-DEFINE RecordPhrase07          YES              /* Determina que existe for each para record-phrase 7 */
&GLOBAL-DEFINE EachRecordPhrase07 ~
            Find {&Table} no-lock ~
                    Where {&Table}.ep-codigo      = ttParam{&Table}.ep-codigo-ini      ~
                    And   {&Table}.conta-contabil = ttParam{&Table}.conta-contabil-ini ~
                    no-error. ~
            Run CreateOutputRecord. 

/* record-phrase = 8 */
&GLOBAL-DEFINE RecordPhrase08          YES              /* Determina que existe for each para record-phrase 8 */
&GLOBAL-DEFINE EachRecordPhrase08 ~
            If   ttParam{&Table}.titulo-ini = ttParam{&Table}.titulo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.titulo = ttParam{&Table}.titulo-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.titulo-ini <> ttParam{&Table}.titulo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.titulo >= ttParam{&Table}.titulo-ini ~
                    And   {&Table}.titulo <= ttParam{&Table}.titulo-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */

/******************  ForEachRecord Preprocessor Definitions End  *****************/


/*********************************  Program Beg *********************************/
{bcp/bcbo.i}
/*********************************  Program End *********************************/

  
