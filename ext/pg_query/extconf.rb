# rubocop:disable Style/GlobalVars

require 'mkmf'
#require 'open-uri'

workdir = Dir.pwd
libdir = File.join(workdir, 'libpg_query')

# Download & compile PostgreSQL if we don't have it yet
#
# Note: We intentionally use a patched version that fixes bugs in outfuncs.c
unless Dir.exist?(libdir)
  #unless File.exist?("#{workdir}/postgres.tar.gz")
  #  File.open("#{workdir}/postgres.tar.gz", 'wb') do |target_file|
  #    open('https://codeload.github.com/pganalyze/postgres/tar.gz/pg_query', 'rb') do |read_file|
  #      target_file.write(read_file.read)
  #    end
  #  end
  #end
  #system("tar -xf #{workdir}/postgres.tar.gz") || fail('ERROR')
  system("cp -a /Users/lfittl/Code/libpg_query #{libdir}") || fail('ERROR')
  system("cd #{libdir}; make")
end

$objs = ["#{libdir}/libpg_query.a", 'pg_query_ruby.o']

$CFLAGS << " -I #{libdir} -O2 -Wall -Wmissing-prototypes -Wpointer-arith -Wdeclaration-after-statement -Wendif-labels -Wmissing-format-attribute -Wformat-security -fno-strict-aliasing -fwrapv"

SYMFILE = File.join(File.dirname(__FILE__), 'pg_query_ruby.sym')
if RUBY_PLATFORM =~ /darwin/
  $DLDFLAGS << " -Wl,-exported_symbols_list #{SYMFILE}" unless defined?(::Rubinius)
else
  $DLDFLAGS << " -Wl,--retain-symbols-file=#{SYMFILE}"
end

create_makefile 'pg_query/pg_query'
