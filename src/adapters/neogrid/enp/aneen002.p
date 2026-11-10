/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEEN002 2.00.00.006} /*** "010006" 13/08/2025 16:20:11  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneen002 MAN}
&ENDIF

{include/i_fncrowid.i}

/********************************************************************************
** Programa : aneen002.p
** Fun‡Æo   : Carrega TEMP_TABLES necess rias para o SENDER do item 
** Parametros
** Entrada  : Codigo do item  
** Data     : 24/05/2001
** Autor    : Anderson Elton Kruger
** Versao   : 2.00.00.002 (07/02/2002) - Jurandir Steffens
**            Alterado para enviar a mensagem XML caso exista
**            algum registro na tabela de parametros NGAdapterParms.
********************************************************************************/

&IF "{&ROWID_READY}" = "YES" &THEN
   DEF INPUT PARAM p-recid-item AS ROWID.
&ELSE   
   DEF INPUT PARAM p-recid-item AS RECID.
&ENDIF

/********************************************************************************************
** Temp-table tt-item : Temp-table que vai possuir as informa‡äes 
** referentes ao cadastro de Itens.
** Nome do Include com os Parƒmetros: adapters/neogrid/enp/aneen001.i
*********************************************************************************************/
{adapters/neogrid/enp/aneen001.i} 

/********************************************************************************************
** Temp-table tt-to-role : Temp-table que vai possuir as informa‡äes 
** referentes ao destinat rio da mensagem.
** Nome do Include com os Parƒmetros: adapters/neogrid/enp/aneen002.i
*********************************************************************************************/
{adapters/neogrid/enp/aneen002.i} 

/********************************************************************************************
** Temp-table tt-from-role : Temp-table que vai possuir as informa‡äes 
** referentes a origem da mensagem.
** Nome do Include com os Parƒmetros: adapters/neogrid/enp/aneen003.i
*********************************************************************************************/
{adapters/neogrid/enp/aneen003.i} 


FIND FIRST para-ped NO-LOCK NO-ERROR.



CREATE tt-from-role.
ASSIGN tt-from-role.local-orig = para-ped.estab-padrao.

CREATE tt-to-role.
ASSIGN tt-to-role.local-dest = para-ped.estab-padrao.

FIND item NO-LOCK 
    WHERE &IF "{&ROWID_READY}" = "YES" &THEN
             ROWID(ITEM) = p-recid-item
          &ELSE   
             RECID(item) = p-recid-item 
          &ENDIF
             NO-ERROR.
IF AVAILABLE(item) THEN DO:

  CREATE tt-item.
  FIND narrativa OF item NO-LOCK NO-ERROR.
  IF AVAILABLE(narrativa) THEN DO:
    ASSIGN tt-item.narrativa = narrativa.descricao.
  END.
  FIND FIRST item-fornec OF item NO-LOCK NO-ERROR.
  IF AVAILABLE(item-fornec) THEN DO:
    ASSIGN tt-item.manufacturer = item-fornec.cod-emitente.
  END.
  IF item.tipo-con-est = 4 THEN DO:
     FIND FIRST ref-item WHERE item.it-codigo = ref-item.it-codigo NO-LOCK NO-ERROR.
     IF AVAILABLE(ref-item) THEN DO:
        ASSIGN tt-item.reference = ref-item.cod-refer.
     END.
  END.
  BUFFER-COPY item TO tt-item.

  IF CONNECTED("neogrid") THEN DO:
    RUN adapters/neogrid/enp/aneen001.p (input table tt-item, 
                                       input table tt-from-role, 
                                       input table tt-to-role).
  END.
    
end.


/***************************************************************************
** fim de programa
***************************************************************************/

