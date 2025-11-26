// frontend/src/components/ApiHealthCheck.tsx
import { useEffect, useState } from 'react';

type HealthResponse = {
  status: string;
  app: string;
  time: string;
};

export const ApiHealthCheck = () => {
  const [data, setData] = useState<HealthResponse | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchHealth = async () => {
      try {
        const res = await fetch('/api/health');
        if (!res.ok) {
          throw new Error(`HTTP ${res.status}`);
        }
        const json = (await res.json()) as HealthResponse;
        setData(json);
      } catch (e) {
        setError((e as Error).message);
      }
    };

    fetchHealth();
  }, []);

  if (error) {
    return <div style={{ color: 'red' }}>API error: {error}</div>;
  }

  if (!data) {
    return <div>Checking API health...</div>;
  }

  return (
    <div>
      <h2>API Health</h2>
      <ul>
        <li>status: {data.status}</li>
        <li>app: {data.app}</li>
        <li>time: {data.time}</li>
      </ul>
    </div>
  );
};
