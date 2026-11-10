/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCBO1008 2.00.00.005 } /*** 010005 ***/


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bcbo1008.p
**
**   VersÆo....: 02.00.00 - Datasul
**
**   Objetivo..: BO de Acesso a tabela Item do datasul-EMS 2 para o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/


/***********************  General Preprocessor Definitions Beg  ******************/
&GLOBAL-DEFINE Table Item
&GLOBAL-DEFINE ProductName datasul-EMS2
&GLOBAL-DEFINE LocalNumber 3 /** datasul-EMS 2 **/
/***********************  General Preprocessor Definitions End  ******************/


/********************************  Includes Beg  ********************************/
{bcp/bc8108.i}   /* Temporary Tables Definition */
{bcp/bcproxy.i1} /* Standard Tables Definition  */
/********************************  Includes End  ********************************/


/****************  CreateOutputRecord Preprocessor Definitions Beg  **************/

/****************  CreateOutputRecord Preprocessor Definitions End  **************/

/*******************  FindRecord Preprocessor Definitions Beg  *******************/
&GLOBAL-DEFINE FindKeyPhrase ~
                Where {&Table}.it-codigo = ttParam{&table}.it-codigo-ini 
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
            If   ttParam{&Table}.cod-estabel-ini = ttParam{&Table}.cod-estabel-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.cod-estabel = ttParam{&Table}.cod-estabel-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.cod-estabel-ini <> ttParam{&Table}.cod-estabel-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.cod-estabel >= ttParam{&Table}.cod-estabel-ini ~
                    And   {&Table}.cod-estabel <= ttParam{&Table}.cod-estabel-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ 

/* record-phrase = 3 */
&GLOBAL-DEFINE RecordPhrase03          YES              /* Determina que existe for each para record-phrase 3 */
&GLOBAL-DEFINE EachRecordPhrase03 ~
            If   ttParam{&Table}.fm-codigo-ini = ttParam{&Table}.fm-codigo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.fm-codigo = ttParam{&Table}.fm-codigo-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.fm-codigo-ini <> ttParam{&Table}.fm-codigo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.fm-codigo >= ttParam{&Table}.fm-codigo-ini ~
                    And   {&Table}.fm-codigo <= ttParam{&Table}.fm-codigo-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */

/* record-phrase = 4 */
&GLOBAL-DEFINE RecordPhrase04          YES              /* Determina que existe for each para record-phrase 4 */
&GLOBAL-DEFINE EachRecordPhrase04 ~
            If   ttParam{&Table}.desc-{&Table}-ini = ttParam{&Table}.desc-{&Table}-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.descricao-1 = ttParam{&Table}.desc-{&Table}-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.desc-{&Table}-ini <> ttParam{&Table}.desc-{&Table}-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.descricao-1 >= ttParam{&Table}.desc-{&Table}-ini ~
                    And   {&Table}.descricao-1 <= ttParam{&Table}.desc-{&Table}-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */

/* record-phrase = 5 */
&GLOBAL-DEFINE RecordPhrase05          YES              /* Determina que existe for each para record-phrase 5 */
&GLOBAL-DEFINE EachRecordPhrase05 ~
            If   ttParam{&Table}.tipo-con-est-ini = ttParam{&Table}.tipo-con-est-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.tipo-con-est = ttParam{&Table}.tipo-con-est-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.tipo-con-est-ini <> ttParam{&Table}.tipo-con-est-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.tipo-con-est >= ttParam{&Table}.tipo-con-est-ini ~
                    And   {&Table}.tipo-con-est <= ttParam{&Table}.tipo-con-est-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */

/* record-phrase = 6 */
&GLOBAL-DEFINE RecordPhrase06          YES              /* Determina que existe for each para record-phrase 6 */
&GLOBAL-DEFINE EachRecordPhrase06 ~
            If   ttParam{&Table}.un-ini = ttParam{&Table}.un-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.un = ttParam{&Table}.un-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.un-ini <> ttParam{&Table}.un-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.un >= ttParam{&Table}.un-ini ~
                    And   {&Table}.un <= ttParam{&Table}.un-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */

/* record-phrase = 7 */
&GLOBAL-DEFINE RecordPhrase07          YES              /* Determina que existe for each para record-phrase 7 */
&GLOBAL-DEFINE EachRecordPhrase07 ~
            If   ttParam{&Table}.ge-codigo-ini = ttParam{&Table}.ge-codigo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.ge-codigo = ttParam{&Table}.ge-codigo-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.ge-codigo-ini <> ttParam{&Table}.ge-codigo-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.ge-codigo >= ttParam{&Table}.ge-codigo-ini ~
                    And   {&Table}.ge-codigo <= ttParam{&Table}.ge-codigo-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */

/******************  ForEachRecord Preprocessor Definitions End  *****************/


/*********************************  Program Beg *********************************/
{bcp/bcbo.i}
/*********************************  Program End *********************************/

  
