SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE Caso2_DBII
GO


-- =============================================
-- Author:		Jorge Guti�rrez Cordero
-- Create date: 9/18/2020
-- Description:	Created SP_LogIn
-- =============================================
-- Author:		Jorge Guti�rrez Cordero
-- Change date: 9/19/2020
-- Description:	Updated column call names
-- =============================================
CREATE PROCEDURE SP_LogIn
	
	@pEmail     varchar(100)
	,@pPassword varchar(150)

AS
BEGIN
	
	DECLARE @UserId INT

	DECLARE @InvalidLogInSeverity INT
	SET     @InvalidLogInSeverity = 1

	DECLARE @InvalidLoginState INT
	SET     @InvalidLoginState = 5000

	-- Email and password validation

	SELECT 
		@UserId = u.ID
	FROM 
		dbo.[User] AS u
	WHERE 
		u.Email = @pEmail AND u.Password = @pPassword

	IF @UserId IS NULL
	BEGIN
		RAISERROR('Email o contrase�a invalidos.', @InvalidLogInSeverity, @InvalidLoginState)
	END

	-- Select de los permisos

    SELECT DISTINCT
		p.Code
	FROM 
		Permisos AS p
	INNER JOIN
		PermisosPorRol AS pr
		ON
			p.ID = pr.Permiso_id
	INNER JOIN 
		UsersPorRol AS ur
		ON
			ur.[User_id] = @UserId AND ur.Rol_id = pr.Rol_id
	INNER JOIN 
		PermisosPorUsuario AS pu
		ON 
			pu.[User_id] = @UserId AND pu.ID = p.Permiso_id
END
GO
