**free
//==============================================================================
//@name.....: CATP00201
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Lógica de acceso a datos de Categorías y Bitácora de Categorías.
//==============================================================================
Ctl-Opt NoMain;

//-------------------------------------------
//  PROTOTIPOS
//-------------------------------------------
// Lógica de acceso a datos
/Include LIBDGR/QSRCTXT,CATP00201X

//------------------------------------------------------------------------------
//@name.....: CATP00201_getCategory
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Obtener el detalle de una categoría en específico.
//------------------------------------------------------------------------------
//@paramin..: @i_categoryId -> Id de categoría
//            @o_category   -> Estructura de datos para la categoría
//@paramout.: ind           -> Indicador de ejecución del procedimiento
//@exception: N/A
//------------------------------------------------------------------------------
Dcl-Proc CATP00201_getCategory Export;
  Dcl-Pi *n ind;
    @i_categoryId Char(5) Const;
    @o_dsCategoryInfo LikeDs(CATP00201_DScategoryDetail);
  End-Pi;

  Exec Sql
    Select CATIDCATE, CATDESCRI, CATDETALE
      Into :@o_dsCategoryInfo
    From CATEGORIA
    Where CATIDCATE = :@i_categoryId
    Fetch First 1 Row Only;

  Return (SqlCode = 0);

End-Proc;

//------------------------------------------------------------------------------
//@name.....: CATP00201_getAllCategories
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Obtener el detalle de todas las categorías.
//------------------------------------------------------------------------------
//@paramin..: @i_filter -> Filtro a aplicar en el where de la consulta sql
//@paramout.: ind       -> Indicador de ejecución del procedimiento
//@exception: N/A
//------------------------------------------------------------------------------
Dcl-Proc CATP00201_getAllCategories Export;
  Dcl-Pi *n ind;
    @i_filter Char(40) Const;
  End-Pi;
  Dcl-S filter2 Char(45) Inz;

  If (@i_filter <> *Blanks);
    filter2 = '%' + %Trim(@i_filter) + '%';
  EndIf;

  Exec Sql Declare allCategories Insensitive Cursor For
    Select CATIDCATE, CATDESCRI, CATDETALE
    From CATEGORIA
    Where 1 = Case
                When (:@i_filter = '') Then 1
                When (Ucase(CATIDCATE) Like Trim(:filter2)) Then 1
                When (Ucase(CATDESCRI) Like Trim(:filter2)) Then 1
                When (Ucase(CATDETALE) Like Trim(:filter2)) Then 1
                Else 0
              End
    Order By CATIDCATE;

  Exec Sql Open allCategories;

  Return (SqlCode = 0);

End-Proc;

//------------------------------------------------------------------------------
//@naee.....: CATP00201_getNextCategory
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Obtener la siguiente categoría del detalle de categorías.
//------------------------------------------------------------------------------
//@paramin..: @o_dsCategoryInfo -> Estructura de datos para la categoría
//@paramout.: ind               -> Indicador de ejecución del procedimiento
//@exception: N/A
//------------------------------------------------------------------------------
Dcl-Proc CATP00201_getNextCategory Export;
  Dcl-Pi *n ind;
    @o_dsCategoryInfo LikeDs(CATP00201_DScategoryDetail);
  End-Pi;

  Exec Sql Fetch Next From allCategories Into :@o_dsCategoryInfo;

  Return (SqlCode = 0);

End-Proc;

//------------------------------------------------------------------------------
//@name.....: CATP00201_closeAllCategoriesCursor
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Cerrar el cursor que contiene el detalle de todas las categorías.
//------------------------------------------------------------------------------
//@paramin..: N/A
//@paramout.: N/A
//@exception: N/A
//------------------------------------------------------------------------------
Dcl-Proc CATP00201_closeAllCategoriesCursor Export;
  Dcl-Pi *n;
  End-Pi;

  Exec Sql Close allCategories;

End-Proc;

//------------------------------------------------------------------------------
//@name.....: CATP00201_insertCategory
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Insertar registro en tabla base CATEGORIA.
//------------------------------------------------------------------------------
//@paramin..: @i_dsCategoryInfo -> Estructura de datos con valores a insertar
//@paramout.: ind               -> Indicador de ejecución del procedimiento
//@exception: N/A
//------------------------------------------------------------------------------
Dcl-Proc CATP00201_insertCategory Export;
  Dcl-Pi *n ind;
    @i_dsCategoryInfo LikeDs(CATP00201_DScategoryDetail) Const;
  End-Pi;
  Dcl-S success Ind Inz(*Off);

  Exec Sql
    Insert Into CATEGORIA (
      CATIDCATE,
      CATDESCRI,
      CATDETALE
    )
    Values (
      :@i_dsCategoryInfo.categoryId,
      :@i_dsCategoryInfo.categoryDescription,
      :@i_dsCategoryInfo.categoryDetail
    );

  If (SqlCode = 0);
    success = *On;
  EndIf;

  Return success;

End-Proc;

//------------------------------------------------------------------------------
//@name.....: CATP00201_updateCategory
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Actualizar registro en tabla base CATEGORIA.
//------------------------------------------------------------------------------
//@paramin..: @i_dsCategoryInfo -> Estructura de datos con valores a actualizar
//@paramout.: ind               -> Indicador de ejecución del procedimiento
//@exception: N/A
//------------------------------------------------------------------------------
Dcl-Proc CATP00201_updateCategory Export;
  Dcl-Pi *n ind;
    @i_dsCategoryInfo LikeDs(CATP00201_DScategoryDetail) Const;
  End-Pi;
  Dcl-S success Ind Inz(*Off);

  Exec Sql
    Update CATEGORIA
    Set CATDESCRI = :@i_dsCategoryInfo.categoryDescription,
        CATDETALE = :@i_dsCategoryInfo.categoryDetail
    Where CATIDCATE = :@i_dsCategoryInfo.categoryId;

  If (SqlCode = 0);
    success = *On;
  EndIf;

  Return success;

End-Proc;

//------------------------------------------------------------------------------
//@name.....: CATP00201_deleteCategory
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Eliminar registro en tabla base CATEGORIA.
//------------------------------------------------------------------------------
//@paramin..: @i_categoryId -> Id de categoría a eliminar
//@paramout.: ind           -> Indicador de ejecución del procedimiento
//@exception: N/A
//------------------------------------------------------------------------------
Dcl-Proc CATP00201_deleteCategory Export;
  Dcl-Pi *n ind;
    @i_categoryId Char(5) Const;
  End-Pi;
  Dcl-S success Ind Inz(*Off);

  Exec Sql
    Delete From CATEGORIA
    Where CATIDCATE = :@i_categoryId;

  If (SqlCode = 0);
    success = *On;
  EndIf;

  Return success;

End-Proc;

//------------------------------------------------------------------------------
//@name.....: CATP00201_insertCategoryLog
//@version..: ID-001
//@author...: Danny García Reyes
//@since....: Febrero 2023
//@objective: Insertar registro en tabla bitácora CATEGORIAB.
//------------------------------------------------------------------------------
//@paramin..: @i_dsCategoryLogInfo -> Estructura de datos con valores a insertar
//@paramout.: ind                  -> Indicador de ejecución del procedimiento
//@exception: N/A
//------------------------------------------------------------------------------
Dcl-Proc CATP00201_insertCategoryLog Export;
  Dcl-Pi *n ind;
    @i_dsCategoryLogInfo LikeDs(CATP00201_DScategoryLogDetail) Const;
  End-Pi;
  Dcl-S success Ind Inz(*Off);

  Exec Sql
    Insert Into CATEGORIAB (
      BCATIDCATE,
      BCATFECEVN,
      BCATDESCRI,
      BCATDETALE,
      BCATTIPEVN,
      BCATUSUEVN
    )
    Values (
      :@i_dsCategoryLogInfo.categoryId,
      :@i_dsCategoryLogInfo.eventDate,
      :@i_dsCategoryLogInfo.categoryDescription,
      :@i_dsCategoryLogInfo.categoryDetail,
      :@i_dsCategoryLogInfo.eventType,
      :@i_dsCategoryLogInfo.eventUser
    );

  If (SqlCode = 0);
    success = *On;
  EndIf;

  Return success;

End-Proc;
