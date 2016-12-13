--CREATE IMAGE INTO TABLE
DECLARE

  l_upload_size INTEGER;
  l_upload_blob BLOB;
  l_image_id    NUMBER;
  l_image       ORDSYS.ORDImage;

BEGIN

  --
  -- Get the BLOB of the new image from the APEX_APPLICATION_TEMP_FILES (synonym for WWV_FLOW_TEMP_FILES)
  -- APEX 5.0 change from APEX_APPLICATION_FILES which has been deprecated
  -- APEX_APPLICATION_TEMP_FILES has fewer columns and is missing doc_size
  --

  SELECT
    blob_content
  INTO
    l_upload_blob
  FROM
    apex_application_temp_files
  WHERE
    name = :P3_filename;
  --
  -- Insert a new row into the table, initialising the image and
  -- returning the newly allocated image_id for later use
  --
  INSERT
  INTO
    LANDMARK_INFORMATION_V2
    (
      info_id,
      filename,
      image
    )
    VALUES
    (
      seq_info_id.nextval,
     :P3_filename,
      ORDSYS.ORDImage()
    )
  RETURNING
    info_id, image
  INTO
    l_image_id, l_image;

  -- find the size of BLOB (get doc_size)
  l_upload_size := dbms_lob.getlength(l_upload_blob);
  -- copy the blob into the ORDImage BLOB container
  DBMS_LOB.COPY( l_image.SOURCE.localData, l_upload_blob, l_upload_size );

  -- set the image properties
  l_image.setProperties();

  UPDATE
    LANDMARK_INFORMATION_V2
  SET
    image     = l_image -- original ORDImage image
  WHERE
    info_id = l_image_id;

END;
