/*************************************************************************
**
** SOBRE.I - Include padr∆o para chamada do Sobre
** Data Criaá∆o: 05/01/2005
** Criado por..: KSM35590 - Herc°lio Werneck de Capistrano
**
**************************************************************************/

&IF DEFINED(SYSTEM-VARS) <> 0 &THEN
    DEFINE VARIABLE c-nom-prog-ext     AS CHAR NO-UNDO.
    DEFINE VARIABLE c-nom-prog-ext-aux AS CHAR NO-UNDO.

    ASSIGN c-nom-prog-ext = PROGRAM-NAME(1).
    IF c-nom-prog-ext BEGINS "USER-INTERFACE-TRIGGER":U THEN
        ASSIGN c-nom-prog-ext = substr(c-nom-prog-ext,24)
               file-info:file-name = c-nom-prog-ext
               c-nom-prog-ext-aux = file-info:full-pathname.
    run abp/sobre.p (c-programa-mg97,
                     c-nom-prog-ext-aux,
                     c-versao-mg97).    
&ENDIF

/* abp/sobre.i */

