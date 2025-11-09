
import { NodeSDK } from '@opentelemetry/sdk-node';
import { Resource } from '@opentelemetry/resources';
import { SemanticResourceAttributes } from '@opentelemetry/semantic-conventions';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-http';
import { OTLPMetricExporter } from '@opentelemetry/exporter-metrics-otlp-http';
import { PeriodicExportingMetricReader } from '@opentelemetry/sdk-metrics';
import { HttpInstrumentation } from '@opentelemetry/instrumentation-http';
import { ExpressInstrumentation } from '@opentelemetry/instrumentation-express';
import { PgInstrumentation } from '@opentelemetry/instrumentation-pg';

const serviceName = process.env.OTEL_SERVICE_NAME || 'quantum-wallet-backend';
const endpoint = process.env.OTEL_EXPORTER_OTLP_ENDPOINT || '';

const traceExporter = endpoint ? new OTLPTraceExporter({ url: `${endpoint}/v1/traces` }) : undefined;
const metricExporter = endpoint ? new OTLPMetricExporter({ url: `${endpoint}/v1/metrics` }) : undefined;

const sdk = new NodeSDK({
  resource: new Resource({
    [SemanticResourceAttributes.SERVICE_NAME]: serviceName,
    [SemanticResourceAttributes.DEPLOYMENT_ENVIRONMENT]: process.env.NODE_ENV || 'development',
  }),
  traceExporter,
  metricReader: metricExporter ? new PeriodicExportingMetricReader({ exporter: metricExporter }) : undefined,
  instrumentations: [
    new HttpInstrumentation(),
    new ExpressInstrumentation(),
    new PgInstrumentation(),
  ],
});

export async function startOtel() {
  try {
    await sdk.start();
    if (endpoint) console.log('[otel] started ->', endpoint);
    else console.log('[otel] started (no exporter endpoint configured)');
  } catch (e) {
    console.error('[otel] failed to start', e);
  }
}

export async function shutdownOtel() {
  try {
    await sdk.shutdown();
  } catch (e) {
    console.error('[otel] shutdown error', e);
  }
}
