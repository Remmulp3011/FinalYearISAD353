CREATE OR REPLACE PROCEDURE create_blob_thumbnail (p_info_id IN INTEGER) IS
  l_orig          ORDSYS.ORDImage;
  l_thumb         ORDSYS.ORDImage;
  l_blob_thumb    BLOB;

BEGIN

  -- lock row
  SELECT image
  INTO l_orig
  FROM LANDMARK_INFORMATION_V2
  WHERE info_id = p_info_id FOR UPDATE;

  l_thumb := ORDSYS.ORDImage.Init();

  dbms_lob.createTemporary(l_thumb.source.localData, true);
  ORDSYS.ORDImage.processCopy(l_orig,
                              'maxscale=128 128',
                              l_thumb);

  -- extract BLOB from OrdImage
  UPDATE LANDMARK_INFORMATION_V2
  SET thumbnail = l_thumb.source.localData
  WHERE info_id = p_info_id;

  dbms_lob.freeTemporary(l_thumb.source.localData);

  COMMIT;

END;



BEGIN
  create_blob_thumbnail(2);
  create_blob_thumbnail(4);
END;
