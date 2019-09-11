@testset "Localhost" begin
    wmic_command = "wmic path win32_computersystemproduct get uuid"

    windows_patch = @patch function Sys.iswindows()
        return true
    end

    wmic_patch = @patch function read(command::Cmd, String)
        return "UUID\nEC2D1284-E32E-FB5E-20E4-F43F6E01CA7A"
    end

    @testset "EC2 - Windows" begin
        apply([windows_patch, wmic_patch]) do
            @test localhost_is_ec2()
        end
    end
end