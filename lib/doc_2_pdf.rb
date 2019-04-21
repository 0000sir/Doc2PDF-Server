require 'mimemagic/overlay'
module Doc2Pdf
   DIR = Rails.root.join('storage')
  MIME_EXT = {".doc"=>"application/msword",
              ".docx"=>"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
              ".dotx"=>"application/vnd.openxmlformats-officedocument.wordprocessingml.template",
              ".docm"=>"application/vnd.ms-word.document.macroEnabled.12",
              ".dotm"=>"application/vnd.ms-word.template.macroEnabled.12",
              ".xls"=>"application/vnd.ms-excel",
              ".xlsx"=>"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
              ".xltx"=>"application/vnd.openxmlformats-officedocument.spreadsheetml.template",
              ".xlsm"=>"application/vnd.ms-excel.sheet.macroEnabled.12",
              ".xltm"=>"application/vnd.ms-excel.template.macroEnabled.12",
              ".xlam"=>"application/vnd.ms-excel.addin.macroEnabled.12",
              ".xlsb"=>"application/vnd.ms-excel.sheet.binary.macroEnabled.12",
              ".ppt"=>"application/vnd.ms-powerpoint",
              ".pptx"=>"application/vnd.openxmlformats-officedocument.presentationml.presentation",
              ".potx"=>"application/vnd.openxmlformats-officedocument.presentationml.template",
              ".ppsx"=>"application/vnd.openxmlformats-officedocument.presentationml.slideshow",
              ".ppam"=>"application/vnd.ms-powerpoint.addin.macroEnabled.12",
              ".pptm"=>"application/vnd.ms-powerpoint.presentation.macroEnabled.12",
              ".potm"=>"application/vnd.ms-powerpoint.template.macroEnabled.12",
              ".ppsm"=>"application/vnd.ms-powerpoint.slideshow.macroEnabled.12"
            }.invert

  def convert(file, md5=nil, mime=nil)
    # 0. produce md5 of file if no md5sum provided
    md5 = file_md5(file) if md5.blank?
    p "md5: #{md5}"
    # 1 check file exists, return it directly
    dest = dest_file(md5)
    return dest if File.exists?(dest)
    # 2. convert
    win_convert(file, mime)
    # 3. return pdf file
    return dest.to_s
  end

  def get_file(md5)
    file = dest_file(md5)
    if File.exists?(file)
      return file.to_s
    else
      raise IOError
    end
  end

  def save_uploaded(uploaded_file, mime=nil)
    md5 = file_md5(uploaded_file.tempfile)
    filename = source_file("uploaded_file.original_filename#{guess_ext(mime)}", md5)
    File.open(filename, 'wb') do |file|
      file.write(uploaded_file.tempfile.read)
    end
    return filename, md5
  end

  def file_md5(file)
    require 'digest'
    Digest::MD5.file(file).to_s
  end

  def dest_dir(md5)
    dir = DIR.join(md5)
    FileUtils.mkdir_p(dir) unless File.exists?(dir)
    dir
  end

  def source_file(original_filename, md5)
    ext = File.extname(original_filename)
    dest_dir(md5).join("#{md5}#{ext}")
  end

  def dest_file(md5)
    dest_dir(md5).join("#{md5}.pdf")
  end

  def guess_ext(mime)
    MIME_EXT[mime]
  end

  extend self

  private
  def win_convert(from, mime=nil)
    script = Rails.root.join('bin/doc2pdf.ps1')

    mime = MimeMagic.by_magic(File.open(from)).to_s if mime.blank?

    cmd = "powershell -ExecutionPolicy bypass -F #{script} #{from} #{mime}"

    p cmd

    system(cmd)
  end

end
