@testset "AWS Signature Version 4" begin
    r = @SymDict(
        creds = AWSCredentials("AKIDEXAMPLE","wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY"),
        region = "us-east-1",
        verb = "POST",
        service = "iam",
        url = "http://iam.amazonaws.com/",
        content = "Action=ListUsers&Version=2010-05-08",
        headers = Dict(
            "Content-Type" => "application/x-www-form-urlencoded; charset=utf-8",
            "Host" => "iam.amazonaws.com"
        )
    )

    AWSCore.sign!(r, DateTime("2011-09-09T23:36:00"))

    h = r[:headers]
    out = join(["$k: $(h[k])\n" for k in sort(collect(keys(h)))])

    expected = (
        "Authorization: AWS4-HMAC-SHA256 " *
        "Credential=AKIDEXAMPLE/20110909/us-east-1/iam/aws4_request, " *
        "SignedHeaders=content-md5;content-type;host;" *
        "x-amz-content-sha256;x-amz-date, " *
        "Signature=1a6db936024345449ef4507f890c5161bbfa2ff2490866653bb8b58b7ba1554a\n" *
        "Content-MD5: r2d9jRneykOuUqFWSFXKCg==\n" *
        "Content-Type: application/x-www-form-urlencoded; charset=utf-8\n" *
        "Host: iam.amazonaws.com\n" *
        "x-amz-content-sha256: b6359072c78d70ebee1e81adcbab4f01bf2c23245fa365ef83fe8f1f955085e2\n" *
        "x-amz-date: 20110909T233600Z\n"
    )

    @test out == expected
end