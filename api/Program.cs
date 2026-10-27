using System.Text.Json.Serialization;
using api.Data;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
// IgnoreCycles: Stock.Comments -> Comment.Stock would otherwise loop forever when serialized.
builder.Services.AddControllers().AddJsonOptions(options =>
    options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles);
builder.Services.AddOpenApi();

// Database: PostgreSQL via Entity Framework Core.
// The connection string lives in appsettings*.json under "ConnectionStrings:Default".
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("Default")));

// Allow the frontend (running on a different origin) to call this API.
// Origins are configured in appsettings*.json under "Cors:AllowedOrigins".
var allowedOrigins = builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ?? [];
builder.Services.AddCors(options => options.AddDefaultPolicy(policy =>
    policy.WithOrigins(allowedOrigins)
          .AllowAnyHeader()
          .AllowAnyMethod()));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();

    // Interactive API docs at /swagger, built from the OpenAPI document above.
    app.UseSwaggerUI(options => options.SwaggerEndpoint("/openapi/v1.json", "MyApi v1"));
}

app.UseHttpsRedirection();
app.MapControllers();

app.UseCors();

app.Run();
