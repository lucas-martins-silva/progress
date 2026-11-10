/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bcbo.i
**
**   VersÆo....: 02.00.00 - Datasul
**
**   Objetivo..: BO de Acesso a tabela {&Table} do {&ProductName} para o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**************************** Parameters Definition Beg *************************/
&IF INT(ENTRY(1,PROVERSION,".")) > 8 &THEN
DEF Input  parameter  table         for ttParam{&Table}.
DEF Output parameter  table         for tt{&Table}.
DEF Output parameter  table         for ttReturnMessages.
&ENDIF
/**************************** Parameters Definition End *************************/

/***************************** Variable Definition Beg **************************/
DEF VAR vCodError           AS Integer      no-undo.
DEF VAR vRec                AS Integer      no-undo.
DEF VAR vDesParam           AS Character    no-undo.
DEF VAR vNumEntries         AS Integer      no-undo.
DEF VAR vPrograma           AS Character    no-undo.
/***************************** Variable Definition End **************************/


/*********************************  Program Beg *********************************/

/* Verifica se foram passados parƒmetros para leitura dos registros */
Find First ttParam{&Table} no-lock no-error.
If  Not AvailAble ttParam{&Table} then do:
    Assign vCodError = 1
           vDesParam = ''.
    run CreateReturnMessages (Input vCodError,
                              Input vDesParam).
    Return.
End. /* If Not AvailAble ttParam{&Table} */

Case ttParam{&Table}.acess-mode:
    when 0 then do:
        Run FindCurrentRecord.
    End. /* When 0 */
    when 1 then do:
        Run FindFirstRecord.
    End. /* When 1 */
    when 2 then do:
        Run FindPrevRecord.
    End. /* When 2 */
    when 3 then do:
        Run FindNextRecord.
    End. /* When 3 */
    when 4 then do:
        Run FindLastRecord.
    End. /* When 4 */
    when 5 then do:
        Run ForEachRecord.
    End. /* When 5 */
    when 6 then do:
        Run GetNextRecord.
    End. /* When 6 */
    otherwise do:
        Assign vCodError = 2
               vDesParam = ttParam{&Table}.acess-mode:label in Frame fttParam{&Table} + ' ' +
                           string(ttParam{&Table}.acess-mode).
        run CreateReturnMessages (Input vCodError,
                                  Input vDesParam).
        Return.        
    End. /* otherwise */
End Case. /* Case ttParam{&Table}.acess-mode */

Find First tt{&Table} no-lock no-error.

If   not avail tt{&Table} then do:
        Assign vCodError = 6
               vDesParam = ''.
        run CreateReturnMessages (Input vCodError,
                                  Input vDesParam).
End. /* If ... do: */

RETURN.

/*********************************  Program End *********************************/

/*********************************************************************************
** PROCEDURE FindCurrentRecord.
**
** Esta procedure executa um FIND CURRENT a partir do registro passado como 
** parƒmetro
*********************************************************************************/
Procedure FindCurrentRecord:

    Find {&Table} no-lock 
         {&FindKeyPhrase}
        NO-ERROR.

    Run CreateOutputRecord.

End Procedure. /* FindCurrentRecord */


/*********************************************************************************
** PROCEDURE FindFirstRecord.
**
** Esta procedure apenas executa um FIND FIRST na tabela.
*********************************************************************************/
Procedure FindFirstRecord:
    Find First {&Table} no-lock no-error.
    
    Run CreateOutputRecord.

End Procedure. /* FindFirstRecord */


/*********************************************************************************
** PROCEDURE FindPrevRecord.
**
** Esta procedure executa um FIND PREV a partir do registro passado como parƒmetro
*********************************************************************************/
Procedure FindPrevRecord:
    
    Find {&Table} no-lock 
         {&FindKeyPhrase}
        NO-ERROR.
    
    Find Prev {&Table} no-lock no-error.
    
    Run CreateOutputRecord.

End Procedure. /* FindPrevRecord */


/*********************************************************************************
** PROCEDURE FindNextRecord.
**
** Esta procedure executa um FIND NEXT a partir do registro passado como parƒmetro
*********************************************************************************/
Procedure FindNextRecord:
    
    Find {&Table} no-lock 
         {&FindKeyPhrase}
        NO-ERROR.
    
    Find Next {&Table} no-lock no-error.
    
    Run CreateOutputRecord.

End Procedure. /* FindNextRecord */


/*********************************************************************************
** PROCEDURE FindLastRecord.
**
** Esta procedure apenas executa um FIND LAST na tabela.
*********************************************************************************/
Procedure FindLastRecord:
    Find Last {&Table} no-lock no-error.
    
    Run CreateOutputRecord.

End Procedure. /* FindLastRecord */

/*********************************************************************************
** PROCEDURE GetNextRecord.
**
** Esta procedure le os pr¢ximos N registros de acordo com o parƒmetro num-of-rec.
*********************************************************************************/
Procedure GetNextRecord:
    Assign vRec = 0.
    
    Case ttParam{&Table}.record-phrase:
        When 1 then do:
            &If   '{&RecordPhrase01}' = 'YES' &THEN
                {&EachRecordPhrase01}
            &ENDIF
        End. /* When 1 */        
        When 2 then do:
            &If   '{&RecordPhrase02}' = 'YES' &THEN
                {&EachRecordPhrase02}
            &ENDIF
        End. /* When 2 */        
        When 3 then do:
            &If   '{&RecordPhrase03}' = 'YES' &THEN
                {&EachRecordPhrase03}
            &ENDIF
        End. /* When 3 */        
        When 4 then do:
            &If   '{&RecordPhrase04}' = 'YES' &THEN
                {&EachRecordPhrase04}
            &ENDIF
        End. /* When 4 */        
        When 5 then do:
            &If   '{&RecordPhrase05}' = 'YES' &THEN
                {&EachRecordPhrase05}
            &ENDIF
        End. /* When 5 */        
        When 6 then do:
            &If   '{&RecordPhrase06}' = 'YES' &THEN
                {&EachRecordPhrase06}
            &ENDIF
        End. /* When 6 */        
        When 7 then do:
            &If   '{&RecordPhrase07}' = 'YES' &THEN
                {&EachRecordPhrase07}
            &ENDIF
        End. /* When 7 */        
        When 8 then do:
            &If   '{&RecordPhrase08}' = 'YES' &THEN
                {&EachRecordPhrase08}
            &ENDIF
        End. /* When 8 */        
        When 9 then do:
            &If   '{&RecordPhrase09}' = 'YES' &THEN
                {&EachRecordPhrase09}
            &ENDIF
        End. /* When 9 */        
        When 10 then do:
            &If   '{&RecordPhrase10}' = 'YES' &THEN
                {&EachRecordPhrase10}
            &ENDIF
        End. /* When 10 */        
        OtherWise do:
            Assign vCodError = 6
                   vDesParam = ttParam{&Table}.acess-mode:label in Frame fttParam{&Table} + ' ' +
                               string(ttParam{&Table}.record-phrase).
            run CreateReturnMessages (Input vCodError,
                                      Input vDesParam).
        End. /* OtherWise */
    End Case. /* ttParam{&Table}.record-phrase */ 
    
End Procedure. /* GetNextRecord. */


/*********************************************************************************
** PROCEDURE ForEachRecord.
**
** Esta procedure executa um FOR EACH na tabela conforme os parƒmetros.
*********************************************************************************/
Procedure ForEachRecord:
        
    Case ttParam{&Table}.record-phrase:
        When 1 then do:
            &If   '{&RecordPhrase01}' = 'YES' &THEN
                {&EachRecordPhrase01}
            &ENDIF
        End. /* When 1 */        
        When 2 then do:
            &If   '{&RecordPhrase02}' = 'YES' &THEN
                {&EachRecordPhrase02}
            &ENDIF
        End. /* When 2 */        
        When 3 then do:
            &If   '{&RecordPhrase03}' = 'YES' &THEN
                {&EachRecordPhrase03}
            &ENDIF
        End. /* When 3 */        
        When 4 then do:
            &If   '{&RecordPhrase04}' = 'YES' &THEN
                {&EachRecordPhrase04}
            &ENDIF
        End. /* When 4 */        
        When 5 then do:
            &If   '{&RecordPhrase05}' = 'YES' &THEN
                {&EachRecordPhrase05}
            &ENDIF
        End. /* When 5 */        
        When 6 then do:
            &If   '{&RecordPhrase06}' = 'YES' &THEN
                {&EachRecordPhrase06}
            &ENDIF
        End. /* When 6 */        
        When 7 then do:
            &If   '{&RecordPhrase07}' = 'YES' &THEN
                {&EachRecordPhrase07}
            &ENDIF
        End. /* When 7 */        
        When 8 then do:
            &If   '{&RecordPhrase08}' = 'YES' &THEN
                {&EachRecordPhrase08}
            &ENDIF
        End. /* When 8 */        
        When 9 then do:
            &If   '{&RecordPhrase09}' = 'YES' &THEN
                {&EachRecordPhrase09}
            &ENDIF
        End. /* When 9 */        
        When 10 then do:
            &If   '{&RecordPhrase10}' = 'YES' &THEN
                {&EachRecordPhrase10}
            &ENDIF
        End. /* When 10 */        
        OtherWise do:
            Assign vCodError = 6
                   vDesParam = ttParam{&Table}.acess-mode:label in Frame fttParam{&Table} + ' ' +
                               string(ttParam{&Table}.record-phrase).
            run CreateReturnMessages (Input vCodError,
                                      Input vDesParam).
        End. /* OtherWise */
    End Case. /* ttParam{&Table}.record-phrase */ 

End Procedure. /* FindLastRecord */


/*********************************************************************************
** PROCEDURE CreateOutputRecord.
**
** Esta cria a temp-table de saida.
*********************************************************************************/
Procedure CreateOutputRecord:
    if  not avail {&Table} then do:
        Assign vCodError = 3
               vDesParam = ''.
        run CreateReturnMessages (Input vCodError,
                                  Input vDesParam).
        Return.
    End.
        
    Create tt{&Table}.
    Buffer-Copy {&Table} {&ExceptFields} to tt{&Table}.
    Assign tt{&Table}.Rowid-value = Rowid({&Table}).
    
    /********************
    **  Este c¢digo ‚ utilizado para fazer assign customizado nos campos que ir  sobrepor
    **  o valor do buffer-copy.
    **  Modo de usar:
    ** 
    **  No programa que utiliza esta include definir o pr‚-processador como descrito abaixo 
    **
    **  &GLOBAL-DEFINE CustomAssignField01 tt{&table}.descricao = {&table}.descricao-1 + {&table}.descricao-2
    ********************/
    
    &If "{&CustomAssignField01}" <> '' &THEN
        Assign {&CustomAssignField01}
               {&CustomAssignField02}
               {&CustomAssignField03}
               {&CustomAssignField04}
               {&CustomAssignField05}
               {&CustomAssignField06}
               {&CustomAssignField07}
               {&CustomAssignField08}
               {&CustomAssignField09}
               {&CustomAssignField10}
                .
    &ENDIF
    
End Procedure. /* CreateOutputRecord */


/*********************************************************************************
** PROCEDURE CreateReturnMessages.
**
** Esta cria as mensagens de retorno da BO.
*********************************************************************************/
Procedure CreateReturnMessages:
    DEF INPUT PARAM pCodError   AS Integer          no-undo.
    DEF INPUT PARAM pDesParam   AS Character        no-undo.
    
    DEF VAR vDesError           AS Character        no-undo.
    DEF VAR vNumLocal           AS Integer          no-undo.
    DEF VAR vNumType            AS Integer          no-undo.
    Def Var vLtr                As Character        No-undo.

    Case pCodError:
        When 1 then do:
            {utp/ut-liter.i Parƒmetros_de_Acesso_nÆo_Informados *}
            Assign vDesError = Return-value
                   vNumLocal = {&LocalNumber}
                   vNumType  = 1. 
        End. /* When 1 */
        When 2 then do:
            {utp/ut-liter.i Parƒmetro_de_Acesso_nÆo_Suportado *}
            Assign vDesError = Return-value
                   vNumLocal = {&LocalNumber}
                   vNumType  = 1. 
        End. /* When 2 */
        When 3 then do:
            {utp/ut-liter.i Registro_NÆo_Dispon¡vel_para_sa¡da. *}
            Assign vDesError = Return-value
                   vNumLocal = {&LocalNumber}
                   vNumType  = 2. 
        End. /* When 3 */
        When 4 then do:
            {utp/ut-liter.i Para_acessos_tipo_FIND_somente_o_parƒmetro_inicial_da_chave_‚_ *}
            Assign vLtr = Return-value.
            {utp/ut-liter.i considerado,_o_parƒmetro_final_foi_descosiderado. *}
            Assign vDesError = vLtr +
                               Return-value
                   vNumLocal = {&LocalNumber}
                   vNumType  = 2. 
        End. /* When 4 */
        When 5 then do:
            {utp/ut-liter.i Parƒmetro_desnecess rio_para_acesso_tipo_FIND *}
            Assign vLtr = Return-value.
            {utp/ut-liter.i o(s)_parƒmetro(s)_em_questÆo_foi(ram)_descosiderado(s). *}
            Assign vDesError = vLtr +
                               Return-value
                   vNumLocal = {&LocalNumber}
                   vNumType  = 2. 
        End. /* When 5 */
        When 6 then do:
            {utp/ut-liter.i NÆo_foi_poss¡vel_gerar_qualquer_registro_para_sa¡da. *}
            Assign vDesError = Return-value
                   vNumLocal = {&LocalNumber}
                   vNumType  = 1. 
        End. /* When 6 */
        When 7 then do:
            {utp/ut-liter.i Campo_nÆo_suportado_para_acesso_do_tipo_For_EACH *}
            Assign vDesError = Return-value
                   vNumLocal = {&LocalNumber}
                   vNumType  = 1. 
        End. /* When 7 */
    End. /* Case */
        
    Create ttReturnMessages.
    Assign ttReturnMessages.CodErro    = pCodError
           ttReturnMessages.DesErro    = vDesError
           ttReturnMessages.Local      = vNumLocal
           ttReturnMessages.Type       = vNumType
           ttReturnMessages.Parameters = pDesParam.

End. /* CreateReturnMessages */
