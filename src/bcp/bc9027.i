DEFINE TEMP-TABLE tt-Montagem-Pallet{1} NO-UNDO
    Field cod-usuario      As Character  Format 'x(14)':U          Label 'Usuario' 
    Field cod-coletor      As Character  Format 'x(14)':U          Label 'Coletor' 
    Field cod-equipamento  As Character  Format 'x(14)':U          Label 'Equipamento' 
    Field tipo-equipamento As Integer    Format '>9':U             Label 'Tipo Equipamento'
    FIELD cod-estabel      LIKE estabelec.cod-estabel              LABEL 'Estabelecimento'
    FIELD cod-local        AS CHARACTER    FORMAT 'x(03)':U        LABEL 'Local'
    FIELD id-etiqueta      LIKE wm-etiqueta.id-etiqueta
    FIELD id-agrupador     LIKE wm-etiqueta.id-etiqueta
    FIELD qtd-item         AS DECIMAL
    FIELD qtd-peso         AS DECIMAL
    FIELD it-codigo        AS CHARACTER FORMAT "x(16)"
    FIELD cod-refer        LIKE wm-etiqueta.cod-refer
    FIELD cod-lote         LIKE wm-etiqueta.cod-lote
    FIELD rWmEtiqueta      AS   ROWID.  /* Armazena o rowid da wm-etiqueta */

Define Variable vCodTipoEquip 
    As Character Init ''          No-undo.
Define Variable vLogAtivo 
    As LOGICAL Init No            No-undo.
Define Variable vLogProcesso 
    AS Logical Init No            No-undo.
Define Variable vLogControlaLogin       
    As Logical Init No            No-undo.
DEFINE VARIABLE vnom-estabel
    AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE vnom-local
    AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE vcod-senha   
    AS CHARACTER FORMAT 'x(14)':U NO-UNDO.
DEFINE VARIABLE hbosc074     
    AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbcapiwms   
    AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbosc047    
    AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbosc092    
    AS HANDLE                     NO-UNDO.
