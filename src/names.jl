#==============================================================================#
# names.jl
#
# AWS Endpoint URLs and Amazon Resource Names.
#
# http://docs.aws.amazon.com/general/latest/gr/rande.html
# http://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html
#
# Copyright OC Technology Pty Ltd 2014 - All rights reserved
#==============================================================================#


export aws_endpoint, arn, arn_region



"""
    aws_endpoint(service, [region, [hostname_prefix]])

Generate service endpoint URL for `service` and  `region`.
"""

function aws_endpoint(service, region="", hostname_prefix="")

    protocol = "http"

    # HTTPS where required...
    if service in ["iam", "sts", "lambda", "apigateway", "email"]
        protocol = "https"
    end

    # Identity and Access Management API has no region suffix...
    if service == "iam"
        region = ""
    end

    # SES not available in all regions...
    if service == "ses" && !(region in ["us-east-1", "us-west-2", "eu-west-1"])
        region = "us-east-1"
    end

    # No region sufix for s3 or sdb in default region...
    if region == "us-east-1" && service in ["s3", "sdb"]
        region = ""
    end

    # Append region to service...
    if region != ""
        if service == "s3"
            service = "$service-$region"
        else
            service = "$service.$region"
        end
    end

    # Add optional hostname prefix (e.g. S3 Bucket Name)...
    if hostname_prefix != ""
        service = "$hostname_prefix.$service"
    end

    return "$protocol://$service.amazonaws.com"
end




"""
    arn([::AWSConfig], service, resource, [region, [account]])

Generate an [Amazon Resource Name](http://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html) for `service` and `resource`.
"""

function arn(service, resource,
             region=get(default_aws_config(), :region, ""),
             account=aws_account_number(default_aws_config()))

    if service == "s3"
        region = ""
        account = ""
    elseif service == "iam"
        region = ""
    end

    "arn:aws:$service:$region:$account:$resource"
end


function arn(aws::AWSConfig,
             service,
             resource,
             region=get(aws, :region, ""),
             account=aws_account_number(aws))

    arn(service, resource, region, account)
end


"""
    arg_region(arn)

Extract region name from `arn`.
"""

arn_region(arn) = split(arn, ":")[4]


#==============================================================================#
# End of file.
#==============================================================================#