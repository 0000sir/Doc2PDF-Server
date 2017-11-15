module Doc2Pdf
  DIR = Rails.root.join('storage')

  def convert(file, md5=nil)
    # 0. produce md5 of file if no md5sum provided
    md5 = file_md5(file) if md5.blank?
    p "md5: #{md5}"
    # 1 check file exists, return it directly
    dest = dest_file(md5)
    return dest if File.exists?(dest)
    # 2. convert
    win_convert(file, dest)
    # 3. return pdf file
    return dest.to_s
  end

  def get_file(md5)
    file = dest_file(md5)
    if File.exists(file)
      return file.to_s
    else
      raise IOError
    end
  end

  def save_uploaded(uploaded_file)
    md5 = file_md5(uploaded_file.tempfile)
    filename = source_file(uploaded_file.original_filename, md5)
    File.open(filename, 'wb') do |file|
      file.write(tempfile.read)
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

  extend self

  private
  def win_convert(from, to)
    script = Rails.root.join('bin/doc2pdf.ps1')

    cmd = "powershell -ExecutionPolicy bypass -F #{script} #{from}"

    p cmd

    system(cmd)
  end

end
