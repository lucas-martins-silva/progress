/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9029A 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9029a MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9029a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - Abril/2005 - Paulo Eduardo Budal                            **
**                                                                                         **
**   Objetivo..: Manuten»’o - montagem de pallet wms                                       **
**                                                                                         **
**   Includes..: bcp/bc9127.i                                                              **
**                                                                                         **
********************************************************************************************/

/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields     tt-storage-serial-wms.cod-usuario        ~
                               tt-storage-serial-wms.cod-coletor        ~
                               tt-storage-serial-wms.cod-equipamento    ~
                               tt-storage-serial-wms.num-serial         ~
                               tt-storage-serial-wms.des-endereco       ~
                               tt-storage-serial-wms.cod-item           ~
                               tt-storage-serial-wms.num-box-lido       ~
                               tt-storage-serial-wms.cod-estabel        ~
                               tt-storage-serial-wms.cod-local          ~
                               tt-storage-serial-wms.id-docto           ~
                               tt-storage-serial-wms.ind-tipo-movto     ~
                               tt-storage-serial-wms.id-movto           ~
                               tt-storage-serial-wms.num-seq-item       ~
                               tt-storage-serial-wms.num-box            ~
                               tt-storage-serial-wms.tipo-equipamento   ~
                               tt-storage-serial-wms.qtd-saldo          ~
                               tt-storage-serial-wms.horario-inicio     ~
                               tt-storage-serial-wms.dat-atualizacao    ~
                               tt-storage-serial-wms.dat-transacao          



/********************  Frame Fields Preprocessor Definitions End  ***************/
/*****************  Name of TT Include Preprocessor Definitions Beg  ************/

&GLOBAL-DEFINE NameOfTTInclude bcp/bc9029.i

/*****************  Name of TT Include Preprocessor Definitions End  ************/
/*******************  Program Title Preprocessor Definitions Beg  ***************/

&GLOBAL-DEFINE ProgramBC9029A

/*******************  Program Title Preprocessor Definitions End  ***************/
/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2

/**************  Frame Number of Columns Preprocessor Definitions End  **********/
/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/

&GLOBAL-DEFINE TransactionProgram bc9029

/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-storage-serial-wms

/**********************  Table Preprocessor Definitions End  ********************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                          "Serial: "     +  STRING({&Table}.num-serial)     + ~
                          "id-Docto: "   +  STRING({&table}.id-docto)       + ~
                          "id-Movto: "   +  STRING({&table}.id-movto)       + ~
                          "NumSeqItem: " +  STRING({&Table}.num-seq-item)   + ~
                          "Item: "       +  STRING(TRIM({&Table}.cod-item)) + ~
                          "idBox: "      +  STRING({&Table}.num-box)

/**********************  Table Preprocessor Definitions End  ********************/

/**************  Fields Custom Display Preprocessor Definitions Beg  ************/

/*&GLOBAL-DEFINE CustomDisplayField01 tt-transfere-bc.data-transacao
&GLOBAL-DEFINE CustomValueField01   String(today,'99/99/9999')*/

/**************  Fields Custom Display Preprocessor Definitions End  ************/
/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/
/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}


