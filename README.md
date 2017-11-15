# Doc2PDF-Server
An api server converts office files to pdf with microsoft office. Using powershell script from [escottj/Doc2PDF](https://github.com/escottj/Doc2PDF)

## How to
This server runs on Windows only because we're using Microsoft Office to generate the perfect formated PDFs.

### 1. Install RubyOnRails for Windows
I used [RailsInstaller](http://railsinstaller.org) to do this. Before today I never used ruby on Windows, It worked perfectly, so it should be easy. Just click to run. Windows 7 x64 with sp1 for me, I didn't test any other version, but I think it will work.

**Note: PowerShell is required for this server.**

### 2. Check out scripts
After the 1st step, you will have git installed, run it:

```
git clone https://github.com/0000sir/Doc2PDF-Server.git
```

### 3. Get your environment ready
Install gems with bundler

```
cd Doc2PDF-Server
bundle install
```

You may need to change gems source in Gemfile, I used ruby-china mirrro.

### 4. Run it
Simply use rails s for running

```
rails s -b 0.0.0.0 -p 80
```

That's it.
