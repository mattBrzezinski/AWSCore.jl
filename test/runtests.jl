#==============================================================================#
# AWSCore/test/runtests.jl
#
# Copyright OC Technology Pty Ltd 2014 - All rights reserved
#==============================================================================#

using AWSCore
using Dates
using HTTP
using HTTP: Headers, URI
using IniFile
using JSON
using Mocking
using Retry
using SymDict
using Test
using XMLDict

Mocking.activate()

aws = aws_config()
include("aws4.jl")
include("arn.jl")
include("credentials.jl")
include("exceptions.jl")
include("signaturev4.jl")
include("xml.jl")
