export interface Transaction {
  id?: string;
  wallet_id: string;
  amount: number;
  type: string;
  status?: string;
  location?: { lat: number; lng: number };
  metadata?: any;
  created_at?: Date;
}
