require 'minitest/spec'

class NetvaultSpec < MiniTest::Chef::Spec
  describe "netvault" do
    include MiniTest::Chef::Resources
    include MiniTest::Chef::Assertions

    describe_recipe "netvault_test::default" do
      it "should have the development libraries for libaio1 installed" do
        package('libaio1').must_be_installed
      end
      it "should have the development libraries for libstdc++5 installed" do
        package('libstdc++5').must_be_installed
      end

      it "should have a directory called /tmp/netvault" do
        directory("#{Chef::Config['file_cache_path']}/netvault").must_exist
      end

      describe "should have a responsefile which contains" do
        let(:config) { file("#{Chef::Config['file_cache_path']}/netvault/responsefile") }

        it { config.must_exist }
        it { config.must_include 'PKG_BASE="/usr/local/netvault"' }
        it { config.must_include 'PASSWORD="PMDSupPorT123"' }
        it { config.must_include 'LOGICAL_NAME="default-ubuntu-1204"' }
      end
    end
  end
end
