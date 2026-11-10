/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCBO1007 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcbo1007 MBC}
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
**   Programa..: BCBO1007.p
**
**   VersÆo....: 02.00.00 - Datasul
**
**   Objetivo..: BO de Acesso a tabela Familia do datasul-EMS 2 para o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/***********************  General Preprocessor Definitions Beg  ******************/
&GLOBAL-DEFINE Table Familia
&GLOBAL-DEFINE ProductName datasul-EMS
&GLOBAL-DEFINE LocalNumber 3 /** datasul-EMS 2 **/
/***********************  General Preprocessor Definitions End  ******************/


/********************************  Includes Beg  ********************************/
{bcp/bc8107.i}   /* Temporary Tables Definition */
{bcp/bcproxy.i1} /* Standard Tables Definition  */
/********************************  Includes End  ********************************/


/****************  CreateOutputRecord Preprocessor Definitions Beg  **************/

/****************  CreateOutputRecord Preprocessor Definitions End  **************/


/*******************  FindRecord Preprocessor Definitions Beg  *******************/
&GLOBAL-DEFINE FindKeyPhrase ~
                Where {&Table}.fm-codigo = ttParam{&Table}.fm-codigo-ini 
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

/* record-phrase = 2 */
&GLOBAL-DEFINE RecordPhrase02          YES              /* Determina que existe for each para record-phrase 2 */
&GLOBAL-DEFINE EachRecordPhrase02 ~
            If   ttParam{&Table}.descricao-ini = ttParam{&Table}.descricao-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.descricao = ttParam{&Table}.descricao-ini: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ ~
            If   ttParam{&Table}.descricao-ini <> ttParam{&Table}.descricao-fim then do: ~
                 For Each {&Table} no-lock ~
                    Where {&Table}.descricao >= ttParam{&Table}.descricao-ini ~
                    And   {&Table}.descricao <= ttParam{&Table}.descricao-fim: ~
                    {&NumRecords} ~
                    Run CreateOutputRecord. ~
                 End. /* Each {&Table} */ ~
            End. /* If ... do: */ 

/******************  ForEachRecord Preprocessor Definitions End  *****************/


/*********************************  Program Beg *********************************/
{bcp/bcbo.i}
/*********************************  Program End *********************************/
  
