FROM python:3.11-slim as builder

WORKDIR /app

COPY pyproject.toml ./

RUN pip install .[test]

COPY . .

FROM python:3.11-slim as runtime

RUN useradd -m appuser

WORKDIR /app

COPY --from=builder /app /app

RUN pip install --no-cache-dir .

USER appuser

EXPOSE 8000

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
